# Self-Hosted Agents on Hetzner Cloud

This repository presents a robust Infrastructure-as-Code (IaC) framework for deploying and managing self-hosted servers on the Hetzner Cloud platform. By harnessing the power of Terraform, the leading infrastructure automation tool, it simplifies the creation, configuration, and maintenance of virtual machine instances. These servers are seamlessly integrated as Azure DevOps agents within the default agent pool and a specified deployment group. The provided Terraform scripts are designed to be executed from within an Azure DevOps build pipeline, thereby enabling on-the-fly scaling and management of server resources as part of your CI/CD workflows.

## Prerequisites

Ensure you have the following prerequisites in place:

1. **Hetzner Cloud API Token**: A token from Hetzner Cloud is required for server provisioning and management.

2. **SSH Key Pair**: Generate an SSH key pair to securely connect to your servers. Remember to have the private key file accessible.

3. **Azure DevOps Personal Access Token**: Secure a personal access token from Azure DevOps with the appropriate permissions for managing agents.

4. **Ephemeral User Credentials**: Set up a temporary username and password for use during server provisioning and configuration.

5. **Terraform Installation**: Install Terraform on your local machine, which is available for download from the [Terraform Downloads](https://www.terraform.io/downloads.html) page.

## Getting Started

Follow these steps to prepare and deploy your self-hosted agents:

1. Clone the project repository to your local machine:

   ```bash
   git clone https://github.com/one-acre-fund/self-hosted-agents
   cd self-hosted-agents
   ```

2. Configure your environment by setting the required environment variables. Terraform recognizes variables prefixed with `TF_VAR_`:

   ```bash
   export TF_VAR_hcloud_api_token="<HETZNER_CLOUD_TOKEN>"
   export TF_VAR_azure_devops_pat="<AZURE_DEVOPS_PAT>"
   export TF_VAR_ssh_private_key_path="<SSH_PRIVATE_KEY_PATH>"
   export TF_VAR_ephemeral_password="<EPHEMERAL_PASSWORD>"
   ```

3. Personalize the Terraform configurations according to your infrastructure needs:

   - Inspect and alter the `terraform.tfvars` and `variables.tf` files as necessary.

4. Initialize Terraform to get your working environment ready:

   ```bash
   terraform init
   ```

5. Plan your infrastructure to review the proposed changes before applying them:

   ```bash
   terraform plan
   ```

6. Execute the Terraform plan to create your infrastructure:

   ```bash
   terraform apply -auto-approve
   ```

## Terraform Configuration

The Terraform files in this project outline your infrastructure blueprint, encompassing server provisioning, software installations, and agent configurations. Customize settings in the `terraform.tfvars` or directly within the Terraform code to align with your project specifications.
