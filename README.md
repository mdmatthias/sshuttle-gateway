# SSH Gateway with sshuttle

This project provides a transparent VPN-like gateway for Docker containers, routing all traffic (TCP and DNS) through a remote SSH server using `sshuttle`.

## How it works

The `sshuttle-gateway` container establishes an SSH connection to a remote host and uses `iptables` to transparently proxy all outgoing traffic from its network namespace. Other containers (like `test-app`) can join this network namespace to have their traffic routed through the tunnel.

Unlike standard SOCKS5 proxies, this setup:
- Handles **DNS resolution** automatically.
- Works with **SSL/HTTPS** without extra configuration.
- Does not require applications to be proxy-aware.

## Prerequisites

- **Docker** and **Docker Compose**.
- **SSH access** to a remote server.
- **SSH keys** located at `~/.ssh` on your host machine.

## Configuration

The gateway requires the `SSH_REMOTE` environment variable to be set. This should be in the format `user@remote-host`.

### Option 1: .env file (Recommended)
Create a `.env` file in the root of the project:
```text
SSH_REMOTE=your-user@your-remote-host
```

### Option 2: Command line
Pass the variable directly to Docker Compose:
```bash
SSH_REMOTE=your-user@your-remote-host docker-compose up --build
```

## Usage

1. **Start the services:**
   ```bash
   docker-compose up --build -d
   ```

2. **Verify the connection:**
   Run a curl command from the `test-app` container to check your external IP or test SSL:
   ```bash
   docker exec -it test-app curl -v https://www.google.com
   ```

3. **Check logs:**
   If you encounter issues, check the gateway logs:
   ```bash
   docker logs -f sshuttle-gateway
   ```
