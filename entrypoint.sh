#!/bin/sh

# Create the .ssh directory
mkdir -p /root/.ssh
if [ -d "/mnt/ssh" ]; then
    cp -r /mnt/ssh/* /root/.ssh/ 2>/dev/null || true
fi

# Fix permissions for SSH
chmod 700 /root/.ssh
find /root/.ssh -type f -exec chmod 600 {} +
find /root/.ssh -type d -exec chmod 700 {} +

# Check if SSH_REMOTE is provided
if [ -z "$SSH_REMOTE" ]; then
    echo "ERROR: SSH_REMOTE environment variable is mandatory."
    echo "Please set it in your docker-compose.yaml or .env file."
    exit 1
fi

# If no arguments are passed, use our default sshuttle command
if [ $# -eq 0 ]; then
    echo "Starting sshuttle for $SSH_REMOTE..."
    exec sshuttle --dns --disable-ipv6 -r "$SSH_REMOTE" 0/0 -v -e "ssh -o StrictHostKeyChecking=accept-new"
else
    # Otherwise, execute whatever was passed
    exec sshuttle "$@"
fi
