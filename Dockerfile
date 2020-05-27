FROM amazonlinux

ADD init.sh /ssh/init.sh
ENTRYPOINT sh /ssh/init.sh
