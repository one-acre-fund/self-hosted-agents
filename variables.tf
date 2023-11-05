# Azure DevOps Configuration
variable "agent_deployment_group_name" {
  description = "Deployment group game to add the agents to"
  type        = string
  default     = "Self Hosted Agents"
}

variable "agent_pool_name" {
  description = "Azure DevOps Pool Name"
  type        = string
  default     = "default"
}

variable "agent_version" {
  description = "Azure DevOps Agent Version"
  type        = string
  default     = "3.227.2"
}

variable "azure_devops_organization" {
  description = "Azure DevOps Organization Name"
  type        = string
  default     = "OAFDev"
}

variable "azure_devops_pat" {
  description = "Azure DevOps Personal Access Token"
  type        = string
  sensitive   = true
}

variable "azure_devops_project" {
  description = "Azure DevOps Project Name"
  type        = string
  default     = "prd-pipelines"
}

# Hetzner Cloud Configuration
variable "hcloud_api_token" {
  description = "Hetzner API Token"
  type        = string
  sensitive   = true
}

variable "hcloud_datacenter" {
  description = "Hetzner Cloud Datacenter"
  type        = string
  default     = "hel1-dc2"
}

variable "hcloud_image" {
  description = "Hetzner Cloud Image"
  type        = string
  default     = "ubuntu-20.04"
}

variable "hcloud_server_count" {
  description = "Number of servers to provision"
  type        = number
  default     = 1
}

variable "hcloud_server_labels" {
  description = "Labels to attach to the Hetzner Cloud servers"
  type        = map(string)
  default     = {
    terraform = "true"
    type      = "self-hosted-agent"
  }
}

variable "hcloud_server_name_prefix" {
  description = "Prefix for the agent names"
  type        = string
  default     = "ubuntu-azure-agent"
}

variable "hcloud_server_type" {
  description = "Hetzner Cloud Server Type"
  type        = string
  default     = "cx11"
}

variable "ssh_key_name" {
  description = "Name of the SSH key in Hetzner"
  type        = string
  default     = "hcloud-terraform"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH key on the local machine"
  type        = string
  default     = "~/.ssh/hcloud_terraform_id_rsa"
  sensitive   = true
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
  default     = "root"
}

# Ephemeral User Configuration
variable "ephemeral_password" {
  description = "Ephemeral Password"
  type        = string
  sensitive   = true
}

variable "ephemeral_user" {
  description = "Ephemeral User"
  type        = string
  default     = "ephemeral_admin"
}
