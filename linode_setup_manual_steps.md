# Manual Provisioning and Configuration Steps for Linode

This document outlines the manual steps required for provisioning and initial configuration of a Linode instance. These steps are performed outside the automated environment but are critical for the subsequent migration process.

## 1. Create a Linode Account:
    *   If you don't have one, sign up for a Linode account at [https://www.linode.com/](https://www.linode.com/).

## 2. Provision a Linode Instance:
    *   Log in to your Linode Cloud Manager.
    *   Click on "Create" and select "Linode."
    *   **Choose a Distribution:** Select a Linux distribution. Ubuntu 22.04 LTS or 20.04 LTS is recommended for good compatibility and long-term support.
    *   **Region:** Select a region geographically close to your users or your development team.
    *   **Linode Plan:** Choose a plan based on your application's resource needs (CPU, RAM, Storage). Start with a modest plan; you can always resize it later. A "Shared CPU" plan like Linode 4GB (2 CPU, 80GB Storage) might be a good starting point for a typical web application.
    *   **Label:** Give your Linode a descriptive label (e.g., `snapp-production-server` or `snapp-staging-server`).
    *   **Root Password:** Create a strong root password.
    *   **SSH Keys (Recommended):** Add your public SSH key(s) to the Linode instance during creation. This is more secure than password authentication. If you don't have an SSH key pair, generate one on your local machine (e.g., using `ssh-keygen`).
    *   **VLANs/Private IP:** Not typically needed for a single server setup unless you have specific networking requirements.
    *   **Backups:** Consider enabling Linode Backups for automated disaster recovery (this is a paid service).
    *   Click "Create Linode." Wait for the Linode to provision and boot up.

## 3. Initial Server Access and Security:
    *   **Access via SSH:** Once the Linode is running, find its public IP address in the Linode Cloud Manager.
        *   If you added an SSH key: `ssh root@<your_linode_ip>`
        *   If using password authentication: `ssh root@<your_linode_ip>` (you'll be prompted for the root password).
    *   **Update System Packages:**
        ```bash
        apt update && apt upgrade -y
        ```
    *   **Create a Non-Root User (Recommended):**
        ```bash
        adduser your_username
        usermod -aG sudo your_username
        ```
        *   If you added an SSH key for root, copy it to the new user:
            ```bash
            rsync --archive --chown=your_username:your_username ~/.ssh /home/your_username/
            ```
        *   Log out and log back in as the new user: `ssh your_username@<your_linode_ip>`
    *   **Configure Firewall (UFW - Uncomplicated Firewall):**
        ```bash
        sudo ufw allow OpenSSH
        sudo ufw allow http       # Port 80
        sudo ufw allow https      # Port 443
        sudo ufw allow 8080     # For Tomcat (if accessed directly)
        sudo ufw allow 1433     # For MS SQL Server (if self-hosted and accessed directly)
        # Add any other ports your application might need, e.g., for Jenkins if hosted on Linode.
        sudo ufw enable
        sudo ufw status
        ```
    *   **Disable Root Login and Password Authentication (Optional but Recommended for Security):**
        *   Edit `/etc/ssh/sshd_config`:
            ```bash
            sudo nano /etc/ssh/sshd_config
            ```
        *   Set `PermitRootLogin no`
        *   Set `PasswordAuthentication no` (ensure SSH key authentication is working for your non-root user before doing this).
        *   Restart SSH service: `sudo systemctl restart sshd`

## 4. Install Docker and Docker Compose:
    *   **Install Docker Engine:**
        ```bash
        # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo           "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu           $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |           sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update

        # Install Docker packages:
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
        ```
    *   **Add your user to the `docker` group (to run Docker commands without `sudo`):**
        ```bash
        sudo usermod -aG docker your_username
        ```
        *   Log out and log back in for this change to take effect, or run `newgrp docker`.
    *   **Verify Docker Installation:**
        ```bash
        docker --version
        docker compose version
        docker run hello-world
        ```

This subtask provides a checklist for the manual setup of the Linode instance. Once these steps are completed by the user/administrator, the Linode instance will be ready for the subsequent migration steps involving database and application deployment.
