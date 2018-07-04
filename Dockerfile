FROM centos:7

LABEL maintainer="Lish" email="pikachust8811@gmail.com"

USER root

RUN yum install -y which

RUN yum install -y java-1.8.0-openjdk-devel.x86_64 && \
  ln -s $(dirname $(dirname $(dirname $(readlink -f /usr/bin/java)))) /usr/local/java
ENV JAVA_HOME=/usr/local/java \
  PATH=$PATH:$JAVA_HOME/bin

RUN yum install -y epel-release && \
  yum install -y python36 && \
  curl -s -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
  python36 /tmp/get-pip.py

RUN echo "alias python=python36" >> ~/.bashrc
RUN echo "alias pm='python36 /data/modugle/main.py'" >> ~/.bashrc

WORKDIR /data/module

COPY bootstrap.sh /etc/bootstrap.sh
RUN chmod +x /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh", "-bash"]