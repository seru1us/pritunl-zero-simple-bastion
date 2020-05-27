#!/bin/bash

hostnamectl set-hostname bastion
TRUSTED_PUBKEY=$(curl $TP_URL)

sudo sed -i '/^TrustedUserCAKeys/d' /etc/ssh/sshd_config
sudo sed -i '/^AuthorizedPrincipalsFile/d' /etc/ssh/sshd_config
sudo tee -a /etc/ssh/sshd_config << EOF

TrustedUserCAKeys /etc/ssh/trusted
AuthorizedPrincipalsFile /etc/ssh/principals
EOF
sudo tee /etc/ssh/principals << EOF
emergency
$PTZ_ROLE
EOF
sudo tee /etc/ssh/trusted << EOF
ssh-rsa $TRUSTED_PUBKEY
EOF

sudo systemctl restart sshd || true
sudo service sshd restart || true
