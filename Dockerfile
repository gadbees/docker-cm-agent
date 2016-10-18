FROM pulsepointinc/centos6-java8:latest

COPY files/etc/yum.repos.d/cloudera-manager.repo /etc/yum.repos.d/

RUN \
  rpm --rebuilddb && \
  yum install -y \
    cloudera-manager-agent \
    ntp && \
  yum clean all

RUN \
  mkdir -p -v /usr/share/java && \
  curl -s -L -o /usr/share/java/mysql-connector-java.jar \
    "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar"

COPY ./files/start.sh /

CMD ["/start.sh"]
