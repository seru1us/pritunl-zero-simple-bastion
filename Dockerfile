FROM amazonlinux

RUN yum update -y
RUN yum install -y openssh

ADD init.sh /ssh/init.sh
ENTRYPOINT sh /ssh/init.sh
