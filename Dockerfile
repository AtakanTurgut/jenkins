FROM jenkins/jenkins:2.332.3-jdk11
USER jenkins
RUN /usr/local/bin/install-plugins.sh blueocean:1.25.3
 