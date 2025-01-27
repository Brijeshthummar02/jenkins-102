# Use the latest Jenkins LTS base image with JDK11
FROM jenkins/jenkins:2.489-jdk17

# Switch to root user to install dependencies
USER root

# Update and install required dependencies
RUN apt-get update && apt-get install -y \
    lsb-release \
    python3-pip \
    curl \
    gnupg \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg

# Set up the stable Docker repository
RUN echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Install the Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Switch back to Jenkins user
USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins "blueocean:1.27.16 docker-workflow:580.vc0c340686b_54"

# Expose Jenkins web interface and agent ports
EXPOSE 8080 50000
