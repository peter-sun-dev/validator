#! /bin/bash

EC2_PUBLIC_IP=$1

# Create systemd Service File
cd /etc/systemd/system
echo "Starting blockchain service..."
echo "
        [Unit]
        Description=Blockchain Node Service
        [Service]
        Type=simple
        Restart=always
        RestartSec=1
        User=$USER
        Group=$USER
        LimitNOFILE=4096
        WorkingDirectory=/home/$USER/node
        ExecStart=polygon-edge server --data-dir /home/$USER/node/data --chain /home/$USER/node/genesis.json --libp2p 0.0.0.0:1478  --nat $EC2_PUBLIC_IP --seal
        [Install]
        WantedBy=multi-user.target
" | sudo tee blockchain.service

if grep -q ForwardToSyslog=yes "/etc/systemd/journald.conf"; then
  sudo sed -i '/#ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
  sudo sed -i '/ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
elif ! grep -q ForwardToSyslog=no "/etc/systemd/journald.conf"; then
  echo "ForwardToSyslog=no" | sudo tee -a /etc/systemd/journald.conf
fi
cd -
echo

# Start systemd Service
sudo systemctl force-reload systemd-journald
sudo systemctl daemon-reload
sudo systemctl start blockchain.service

read -n 1 -s -r -p "Service successfully started! Press any key to continue..."
echo
