# Mini Finance Project - Infrastructure Provisioning with Terraform & Ansible Roles
## Overview

This project demonstrates a production-grade Infrastructure as Code (IaC) and configuration management workflow. It automates the end-to-end provisioning of an AWS EC2 instance using Terraform, followed by modular server configuration and application deployment using Ansible Roles.

The project deploys the Mini Finance static web application on an Amazon Linux server running Nginx.   

## Architecture & Tech Stack

    Cloud Provider: Amazon Web Services (AWS)   

    Infrastructure as Code: Terraform (Provisioning VPC/Subnets, Security Groups, EC2 Instance, Public IP)   

    Configuration Management: Ansible Roles (common, nginx, mini_finance)   

    Web Server: Nginx 

    Application Source: Mini Finance Static Site   

## Project Directory Structure

```text
mini-finance-project/
 ├── terraform/
 │    ├── main.tf
 │    ├── variables.tf
 │    ├── terraform.tfvars
 │    └── outputs.tf
 └── ansible/
      ├── ansible.yml
      ├── inventory.ini
      └── roles/
           ├── common/
           ├── nginx/
           └── mini_finance/
```

## Prerequisites

Before running this project, ensure you have the following tools installed and configured locally:

    Terraform  

    Ansible

    AWS CLI (authenticated via aws configure)   

    An active SSH key pair configured in your AWS account and locally (~/.ssh/id_rsa and ~/.ssh/id_rsa.pub)   

## Deployment Instructions
Step 1: Provision Infrastructure with Terraform
    
Navigate to the terraform directory

```bash
    cd terraform
```
    
Initialize the Terraform workspace:

```bash
    terraform init
```

Review the execution plan:
    
```bash
    terraform plan
```

Apply the configuration to create the AWS resources:

```bash
    terraform apply
```

**Note the Public IP address outputted by Terraform**   

Step 2: Configure Server and Deploy Application with Ansible

Navigate to the ansible directory:
    
```bash
    cd ../ansible
```

Update the inventory.ini file with the Terraform-generated Public IP address (ensure your SSH user matches the EC2 AMI, e.g., ec2-user):

```ini
    [web]
    <Terraform_Public_IP>

    [all:vars]
    ansible_user=ec2-user
    ansible_ssh_private_key_file=~/.ssh/id_rsa
    ansible_python_interpreter=/usr/bin/python3
```

Update the role folder by adding the specific tasks inside it's tasks/main.yml file (common for system packages, nginx for web server setup, and mini_finance for cloning and deploying the GitHub application).

The playbook (ansible.yml) serves as the central control file that executes the roles sequentially. It runs the common, nginx, and mini_finance roles in order to fully configure the server and deploy the application.   

Run the Ansible playbook (ansible.yml) which executes the roles sequentially (common → nginx → mini_finance):   
    
```bash
    ansible-playbook -i inventory.ini ansible.yml
```

## Verification

Once the playbook execution finishes successfully:

Open web browser and navigate to:
`
    http://<Your_Terraform_Public_IP>
`

The live Mini Finance Project website served securely through Nginx should be seen.     

## Cleanup (Optional)

To avoid ongoing costs in cloud environment, destroy the provisioned infrastructure when finished:

```bash
cd terraform

terraform destroy
```
