#FROM 137112412989.dkr.ecr.us-east-1.amazonaws.com/amazonlinux:latest
FROM amazonlinux:latest

RUN yum update -y
RUN yum install -y openssh openssh-server python3

ADD init.sh /ssh/init.sh
ADD press_to_exit.sh /bin/press_to_exit.sh

ENTRYPOINT sh /ssh/init.sh
