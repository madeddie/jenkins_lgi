FROM jenkins
USER root
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections && \ 
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update && apt-get install -y \
    maven \
    oracle-java8-installer && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /var/cache/oracle-jdk8-installer
USER jenkins
RUN mkdir -p /usr/share/jenkins/ref/.ssh && ssh-keyscan -t rsa,dsa github.com 2>&1 | tee /usr/share/jenkins/ref/.ssh/known_hosts
COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
