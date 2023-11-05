terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.44.1"
    }
  }
  required_version = ">= 1.6.2"
}

provider "hcloud" {
  token = var.hcloud_api_token
}

data "hcloud_servers" "self_hosted_agents" {
  with_selector = "type=self-hosted-agent"
}

locals {
  id = length(data.hcloud_servers.self_hosted_agents.servers) + 1
}

resource "hcloud_server" "agents" {
  count       = var.hcloud_server_count
  name        = "${var.hcloud_server_name_prefix}-${local.id + count.index}"
  image       = var.hcloud_image
  server_type = var.hcloud_server_type
  datacenter  = var.hcloud_datacenter
  ssh_keys    = [var.ssh_key_name]
  labels      =  var.hcloud_server_labels
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      # Create user and add to sudoers
      "sudo useradd -m -s /bin/bash ${var.ephemeral_user}",
      # Set password for user
      "echo ${var.ephemeral_user}:${var.ephemeral_password} | sudo chpasswd",
      # Add user to sudoers
      "sudo usermod -aG sudo ${var.ephemeral_user}",
      # Install docker
      "sudo apt install -y docker.io",
      "sudo usermod -aG docker ${var.ephemeral_user}",
      # Install Azure CLI
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      # Install helm
      "curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash",
      # Install kubectl
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin",
      # Install terraform
      "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
      "sudo apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\"",
      "sudo apt update && sudo apt install terraform",
      # Install yq
      "sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64",
      "sudo chmod a+x /usr/local/bin/yq",
      # Install jq
      "sudo apt-get install jq -y",
      # Install zip and unzip
      "sudo apt-get install zip unzip -y",
      # Install Azure DevOps agent dependencies
      "sudo apt-get install apt-transport-https ca-certificates gnupg lsb-release -y",
      "sudo apt-get install software-properties-common -y",
      "sudo apt-get install dnsutils",
      "sudo apt-get install git -y",
      "sudo apt-get install curl -y",
      # Clean up and update packages
      "sudo apt-get autoremove -y",
      "sudo apt-get clean"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.ssh_private_key_path)
      host        = self.ipv4_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p azagent && cd azagent",
      "wget https://vstsagentpackage.azureedge.net/agent/${var.agent_version}/vsts-agent-linux-x64-${var.agent_version}.tar.gz",  # Download Azure DevOps agent package
      "tar zxvf ./vsts-agent-linux-x64-${var.agent_version}.tar.gz",
      "./config.sh --pool ${var.agent_pool_name} --agent ${self.name} --url https://dev.azure.com/${var.azure_devops_organization}/ --projectname '${var.azure_devops_project}' --auth PAT --token ${var.azure_devops_pat} --work _work --acceptteeeula --runasservice --replace",  # Configure and start the agent
      "echo ${var.ephemeral_password} | sudo -S ./svc.sh install",
      "echo ${var.ephemeral_password} | sudo -S ./svc.sh start",
      "echo ${var.ephemeral_password} | sudo -S ./svc.sh status",
      "rm ./vsts-agent-linux-x64-${var.agent_version}.tar.gz",
      "cd ..",
      "mkdir dgagent && cd dgagent",
      "wget https://vstsagentpackage.azureedge.net/agent/${var.agent_version}/vsts-agent-linux-x64-${var.agent_version}.tar.gz",  # Download Azure DevOps agent package
      "tar zxvf ./vsts-agent-linux-x64-${var.agent_version}.tar.gz",
      "./config.sh --deploymentgroup --deploymentgroupname \"${var.agent_deployment_group_name}\" --acceptteeeula --agent ${self.name} --url https://dev.azure.com/${var.azure_devops_organization} --work _work --projectname '${var.azure_devops_project}' --auth PAT --token ${var.azure_devops_pat} --runasservice --replace --unattended",  # Configure and start the agent
      "echo ${var.ephemeral_password} | sudo -S ./svc.sh install",
      "echo ${var.ephemeral_password} | sudo -S ./svc.sh start",
      "echo ${var.ephemeral_password} | sudo -S ./svc.sh status",
      "rm ./vsts-agent-linux-x64-${var.agent_version}.tar.gz"
    ]

    connection {
      type        = "ssh"
      user        = var.ephemeral_user
      password    = var.ephemeral_password
      private_key = file(var.ssh_private_key_path)
      host        = self.ipv4_address
    }
  }
}
