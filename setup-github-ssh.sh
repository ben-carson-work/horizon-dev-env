#!/bin/bash

# Setup GitHub SSH access for Jenkins
# This script helps configure SSH keys for Jenkins to access GitHub repositories

set -e

echo "🔧 Setting up GitHub SSH access for Jenkins..."
echo "=============================================="

# Check if SSH key already exists
if [ -f "./jenkins/ssh/id_rsa" ]; then
    echo "⚠️  SSH key already exists at ./jenkins/ssh/id_rsa"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting without changes."
        exit 0
    fi
    rm -f ./jenkins/ssh/id_rsa ./jenkins/ssh/id_rsa.pub
fi

# Generate SSH key pair
echo "🔐 Generating SSH key pair for Jenkins..."
ssh-keygen -t rsa -b 4096 -C "jenkins@snapp-local" -f ./jenkins/ssh/id_rsa -N ""

# Set proper permissions
echo "🔒 Setting proper file permissions..."
chmod 600 ./jenkins/ssh/id_rsa
chmod 644 ./jenkins/ssh/id_rsa.pub
chmod 644 ./jenkins/ssh/config
chmod 644 ./jenkins/ssh/known_hosts

echo "✅ SSH key pair generated successfully!"
echo ""
echo "📋 Next Steps:"
echo "=============="
echo "1. Copy the public key to your clipboard:"
echo "   cat ./jenkins/ssh/id_rsa.pub"
echo ""
echo "2. Add the public key to GitHub:"
echo "   • Go to GitHub → Settings → SSH and GPG keys"
echo "   • Click 'New SSH key'"
echo "   • Paste the public key content"
echo "   • Give it a title like 'Jenkins SnApp Local'"
echo ""
echo "3. Rebuild and restart Jenkins:"
echo "   docker-compose down"
echo "   docker-compose build jenkins"
echo "   docker-compose up -d"
echo ""
echo "4. Test the SSH connection (should work immediately):"
echo "   docker exec -it snapp-jenkins ssh -T git@github.com"
echo ""
echo "✨ That's it! No manual configuration needed."
echo "   SSH keys are automatically mounted to the correct location."
echo ""
echo "🔑 Your public key is:"
echo "===================="
cat ./jenkins/ssh/id_rsa.pub
echo ""
echo "===================="
echo ""
echo "⚠️  SECURITY WARNING:"
echo "   • Never share the private key (id_rsa)"
echo "   • The private key is automatically ignored by git"
echo "   • Only share the public key (.pub file) with GitHub"