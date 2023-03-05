#!/bin/bash

sudo apt update && apt upgrade -y
sudo apt-get install curl
sudo apt update
sudo apt install docker.io -y
docker --version
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh
chmod +x installer.sh
sudo apt install expect -y

externalip=$(curl https://ipinfo.io/ip)
sudo sed -i '$a\export APP_IP=\"'"${externalip}"'\"' /etc/profile
source /etc/profile

/usr/bin/expect <<-EOF
    set timeout -1
    spawn ./installer.sh
    expect {
        "*data. (y/n)?:" {send "y\r"; exp_continue}
        "*Dashboard? (y/n):" {send "y\r"; exp_continue}
        "*Dashboard:" {send "990726\r"; exp_continue}
        "*(default 8080):" {send "8080\r"; exp_continue}
        "*(default 9001):" {send "9001\r"; exp_continue}
        "*(default 10001):" {send "10001\r"; exp_continue}
        "*(defaults to ~/.shardeum):" {send "\r"}
    }
    expect eof
EOF

cd ~/.shardeum
./shell.sh
export APP_IP="${externalip}"
operator-cli gui start