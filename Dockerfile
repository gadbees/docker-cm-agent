FROM pulsepointinc/centos6-java8:latest

COPY files/etc/yum.repos.d/cloudera-manager.repo /etc/yum.repos.d/

RUN \
  rpm --rebuilddb && \
  yum install -y \
    cloudera-manager-agent
    ntp && \
  yum clean all

RUN \
  mkdir -p -v /usr/share/java && \
  curl -s -L -o /usr/share/java/mysql-connector-java.jar \
    "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar"

RUN \
  mkdir -p -v /opt/cloudera/parcel-cache && \
  curl -s -L -o /opt/cloudera/parcel-cache/CDH-5.7.0-1.cdh5.7.0.p0.45-el6.parcel \
    "http://archive.cloudera.com/cdh5/parcels/5.7.0/CDH-5.7.0-1.cdh5.7.0.p0.45-el6.parcel" && \
  curl -s -L -o /opt/cloudera/parcel-cache/Anaconda-2.5.0-el6.parcel
    "https://repo.continuum.io/pkgs/misc/parcels/archive/Anaconda-2.5.0-el6.parcel"

COPY files/start.sh /

CMD ["/start.sh"]
