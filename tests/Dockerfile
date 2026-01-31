FROM ubuntu:24.04

# Install minimal dependencies to simulate a fresh WSL container
# sudo is often not in default docker images, but is in WSL images
RUN apt-get update && apt-get install -y sudo locales curl git

# Set up a non-root user 'testuser' to enable sudo testing
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser:testuser" | chpasswd && \
    adduser testuser sudo && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

USER testuser
WORKDIR /home/testuser/dotfiles

# Copy the dotfiles into the container
# (We will mount the directory at runtime for faster dev cycle, but for verify we can copy)
# COPY --chown=testuser:testuser . .

CMD ["/bin/bash"]
