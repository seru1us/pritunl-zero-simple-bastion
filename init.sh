#!/bin/bash

useradd bastion

TRUSTED_PUBKEY=$(curl $TP_URL)

sed -i '/^TrustedUserCAKeys/d' /etc/ssh/sshd_config
sed -i '/^AuthorizedPrincipalsFile/d' /etc/ssh/sshd_config
tee -a /etc/ssh/sshd_config << EOF

TrustedUserCAKeys /etc/ssh/trusted
AuthorizedPrincipalsFile /etc/ssh/principals
EOF
tee /etc/ssh/principals << EOF
emergency
$PTZ_ROLE
EOF
tee /etc/ssh/trusted << EOF
ssh-rsa $TRUSTED_PUBKEY
EOF

/usr/bin/ssh-keygen -A
/usr/sbin/sshd -D -f /etc/ssh/sshd_config
