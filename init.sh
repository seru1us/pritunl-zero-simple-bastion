#!/bin/bash

chmod +x /bin/press_to_exit.sh
useradd bastion
usermod --shell /bin/press_to_exit.sh bastion

/usr/bin/ssh-keygen -A -v
mkdir -p $HOME/.ssh/
echo "$BASTION_ID_RSA" > $HOME/.ssh/id_rsa
echo "$BASTION_ID_RSA_PUB" > $HOME/.ssh/id_rsa.pub
echo "$BASTION_SSH_HOST_ED25519_KEY" > /etc/ssh/ssh_host_ed25519_key
echo "$BASTION_SSH_HOST_ED25519_KEY_PUB" > /etc/ssh/ssh_host_ed25519_key.pub
#chmod 600 $HOME/.ssh/id*
#chmod 600 /etc/ssh/ssh_host*
#/usr/bin/ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
ls -la /etc/ssh/
cat /etc/ssh/ssh_host_ed25519_key*

TRUSTED_PUBKEY=$(curl $TP_URL)

sed -i '/^TrustedUserCAKeys/d' /etc/ssh/sshd_config
sed -i '/^AuthorizedPrincipalsFile/d' /etc/ssh/sshd_config
tee -a /etc/ssh/sshd_config << EOF

AllowAgentForwarding no
AllowUsers bastion
AuthorizedPrincipalsFile /etc/ssh/principals
ChallengeResponseAuthentication no
ClientAliveCountMax 240
ClientAliveInterval 120
HostKey /etc/ssh/ssh_host_ed25519_key
PasswordAuthentication no
TrustedUserCAKeys /etc/ssh/trusted
UsePAM no
X11Forwarding no

EOF
tee /etc/ssh/principals << EOF
emergency
$PTZ_ROLE
EOF
tee /etc/ssh/trusted << EOF
$TRUSTED_PUBKEY
EOF

echo starting health check server
python3 -m http.server > /dev/null 2>&1 &

/usr/sbin/sshd -e -D -f /etc/ssh/sshd_config
