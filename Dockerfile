FROM pulsepointinc/centos6-java8:latest

COPY files/etc/yum.repos.d/cloudera-manager.repo /etc/yum.repos.d/

RUN \
  yum install -y \
    cloudera-manager-agent && \
  yum clean all

RUN \
  mkdir -p -v /usr/share/java && \
  curl -s -L -o /usr/share/java/mysql-connector-java.jar \
    "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.38/mysql-connector-java-5.1.38.jar"

COPY files/start.sh /

CMD ["/start.sh"]
