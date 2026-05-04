FROM alpine:3.22.4

# Install dependencies: Python, Pip, OpenSSH, and Iptables
RUN apk add --no-cache \
    python3 \
    py3-pip \
    openssh-client \
    iptables \
    ip6tables \
    curl

# Install sshuttle via pip
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir sshuttle

# sshuttle must run as root to manage container iptables
USER root
ENV HOME=/root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
