# Jenkins SSH Configuration for GitHub Access

This directory contains SSH keys and configuration for Jenkins to access GitHub repositories.

## Setup Instructions

### 1. Generate SSH Key Pair

Run the following command on your host machine to generate an SSH key pair for Jenkins:

```bash
ssh-keygen -t rsa -b 4096 -C "jenkins@snapp-local" -f ./jenkins/ssh/id_rsa -N ""
```

This will create:
- `id_rsa` (private key)
- `id_rsa.pub` (public key)

### 2. Set Proper Permissions

```bash
chmod 600 ./jenkins/ssh/id_rsa
chmod 644 ./jenkins/ssh/id_rsa.pub
chmod 644 ./jenkins/ssh/config
chmod 644 ./jenkins/ssh/known_hosts
```

### 3. Add Public Key to GitHub

1. Copy the content of `jenkins/ssh/id_rsa.pub`:
   ```bash
   cat ./jenkins/ssh/id_rsa.pub
   ```

2. Go to GitHub → Settings → SSH and GPG keys → New SSH key
3. Paste the public key content
4. Give it a title like "Jenkins SnApp Local"

### 4. Test SSH Connection

After rebuilding Jenkins container, test the connection:

```bash
docker exec -it snapp-jenkins ssh -T git@github.com
```

You should see: "Hi [username]! You've successfully authenticated, but GitHub does not provide shell access."

### 5. Rebuild Jenkins Container

After setting up the SSH keys:

```bash
docker-compose down
docker-compose build jenkins
docker-compose up -d
```

## Files in this directory

- `id_rsa` - Private SSH key (you need to generate this)
- `id_rsa.pub` - Public SSH key (you need to generate this)
- `config` - SSH client configuration
- `known_hosts` - GitHub's SSH host keys
- `README.md` - This file

## Security Notes

- Never commit private keys to version control
- The `id_rsa` file should be in your `.gitignore`
- Only the public key (`id_rsa.pub`) can be safely shared