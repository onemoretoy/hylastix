# Hylastix Identity Gateway on Azure

This project deploys a minimal identity gateway environment using Azure VM, Docker containers, Keycloak for authentication, Postgres for identity storage, and a static web page protected via Keycloak login.

Everything is automated using:
- **Terraform** (infrastructure)
- **Ansible** (configuration and containers)
- **GitHub Actions** (CI/CD automation)

---

## Architecture

          ┌────────────────────────┐
          │      Azure VM          │
          │ Ubuntu + Docker        │
          │                        │
          │ ┌───────────────────┐  │
          │ │ hylastix-postgres │◄─┐
          │ └───────────────────┘  │
          │ ┌───────────────────┐  │
          │ │ hylastix-keycloak │─►│ Authentication via Keycloak
          │ └───────────────────┘  │
          │ ┌───────────────────┐  │
          │ │ hylastix-webserver│──┘ Exposed to internet (port 80)
          │ └───────────────────┘
          └────────────────────────┘


#################################################################################

Configuration Before Deployment

1. SSH Key
- Generate SSH key if needed:
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/hylastix_vm_key
- Confirm the public key path in terraform/variables.tf (default: ~/.ssh/hylastix_vm_key.pub)
- Add the **private key content** as a GitHub secret named: SSH_PRIVATE_KEY

2. Terraform Variables
- Update `ssh_public_key_path` in terraform/variables.tf if your key path is different

3. Ansible Inventory
- After Terraform deploys, get the VM's public IP from the output
- Replace <VM_PUBLIC_IP> in ansible/inventory.ini with the actual IP
- Confirm the SSH private key path is correct in the inventory

4. GitHub Secrets
- Add the following GitHub secrets to enable GitHub Actions:
  - `SSH_PRIVATE_KEY`: your private SSH key
  - `VM_PUBLIC_IP`: public IP of the Azure VM

5. Credentials
- Keycloak admin: username=admin, password=admin
- Test user: username=testuser, password=testpass

6. Deployment
- Push to the main branch to trigger GitHub Actions **or** run manually:
  - terraform apply
  - ansible-playbook -i ansible/inventory.ini ansible/site.yml

Note:
The static web page is automatically templated with the VM public IP during deployment — no manual edits needed.

