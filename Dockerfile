FROM amazonlinux

RUN yum update -y
RUN yum install -y openssh openssh-server

ADD init.sh /ssh/init.sh
ADD press_to_exit.sh /bin/press_to_exit.sh

ENTRYPOINT sh /ssh/init.sh
