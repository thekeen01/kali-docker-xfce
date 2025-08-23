#!/bin/bash

# Set password for VNC

mkdir -p /root/.vnc/
echo $VNCPWD | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Set variables

export SHELL=/bin/bash
usermod --shell /bin/bash root
chsh -s /bin/bash root
echo "export SHELL=/bin/bash" >> /root/.profile

update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/xfce4-terminal.wrapper 10

# Start VNC server

if [ $VNCEXPOSE = 1 ]
then
  # Expose VNC
  vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH \
> /var/log/vncserver.log 2>&1
else
  # Localhost only
  vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH -localhost \
> /var/log/vncserver.log 2>&1
fi

/usr/share/novnc/utils/novnc_proxy --listen $NOVNCPORT --vnc localhost:$VNCPORT \
> /var/log/novnc.log 2>&1 &

echo "Launch your web browser and open http://localhost:9020/vnc.html"

/bin/bash
