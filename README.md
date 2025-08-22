# kali-docker-xfce

# What is it

This is a simple example to build a kali docker with an xfce desktop that is accessible via novn in any browser. This is a starting point where you will need to modify the Dockerfile to install all the packages you would use regularly. This has been tested to work with openvpn and HTB to confirm that all networking is good to go. There are many docker examples such as this one. Given that this has a full desktop env, this is not a light docker.

# Building

git clone https://github.com/thekeen01/kali-docker-xfce.git

cd kali-docker-xfce
please adjust the VNCPWD in Dockerfile

docker build -t kalixfce .

# To run

docker run --rm --cap-add=NET_ADMIN -v /dev/net/tun:/dev/net/tun -v /some/path/to/local:/local -it -p 9020:8080 -p 9021:5900 kalixfce

adjust /some/path/to/local to a local folder that you want to share as /local in the docker for easy transfer of files between docker and host

You will be able to access the desktop via http://localhost:9020/vnc.html
