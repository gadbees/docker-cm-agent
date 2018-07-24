FROM pulsepointinc/docker-centos7.5-java8

COPY files/etc/yum.repos.d/cloudera-manager.repo /etc/yum.repos.d/

RUN \
  rpm --rebuilddb && \
  yum install -y \
    cloudera-manager-agent && \
  yum clean all

RUN \
  mkdir -p -v /usr/share/java && \
  curl -s -L -o /usr/share/java/mysql-connector-java.jar \
    "http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.11/mysql-connector-java-8.0.11.jar"

COPY files/start.sh /

CMD ["/start.sh"]
