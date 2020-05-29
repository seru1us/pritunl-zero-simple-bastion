#!/bin/bash

useradd bastion
#usermod --shell /bin/press_to_exit.sh bastion

/usr/bin/ssh-keygen -A

TRUSTED_PUBKEY=$(curl $TP_URL)

sed -i '/^TrustedUserCAKeys/d' /etc/ssh/sshd_config
sed -i '/^AuthorizedPrincipalsFile/d' /etc/ssh/sshd_config
tee -a /etc/ssh/sshd_config << EOF

ChallengeResponseAuthentication no
PasswordAuthentication no
TrustedUserCAKeys /etc/ssh/trusted
AuthorizedPrincipalsFile /etc/ssh/principals
UsePAM no
#ClientAliveInterval 120
#ClientAliveCountMax 240
#X11Forwarding no
#AllowAgentForwarding no

EOF
tee /etc/ssh/principals << EOF
emergency
$PTZ_ROLE
EOF
tee /etc/ssh/trusted << EOF
$TRUSTED_PUBKEY
EOF

/usr/sbin/sshd -D -f /etc/ssh/sshd_config
