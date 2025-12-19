FROM kalilinux/kali-rolling:latest

LABEL website="https://github.com/thekeen01/kali-docker-xfce"
LABEL description="Kali with XFCE GUI in browser using noVNC and openvpn ready"

# Create a kali user
RUN useradd -s /bin/bash -m kali && \
    echo "kali:kali" | chpasswd && \
    usermod -aG sudo kali


# Install kali packages

ARG KALI_METAPACKAGE=core
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install kali-linux-${KALI_METAPACKAGE}
RUN apt-get clean

# Install kali desktop with novnc

ARG KALI_DESKTOP=xfce
RUN apt-get -y install kali-desktop-${KALI_DESKTOP}
RUN apt-get -y install tightvncserver dbus dbus-x11 novnc net-tools websockify

ENV USER root

# Install custom packages/services -- please add whatever you need here

RUN apt-get -y install iputils-ping
RUN apt-get -y install openvpn xfce4-terminal

# Add the user to the sudoers to allow administrative actions
RUN echo 'kali ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/kali
RUN chmod 0440 /etc/sudoers.d/kali

# Setup some kali stuff

RUN usermod --shell /bin/bash kali
RUN chsh -s /bin/bash kali
RUN echo "export SHELL=/bin/bash" >> /home/kali/.profile

RUN update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/xfce4-terminal.wrapper 10

# Set the user
USER kali

# Expose VNC and noVNC ports
EXPOSE 5901 8080

# Start VNC server and noVNC
CMD ["sh", "-c", "vncserver :1 -geometry 1920x1080 -depth 16 && /usr/share/novnc/utils/novnc_proxy --listen 8080 --vnc localhost:5901"]
