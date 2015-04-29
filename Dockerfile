FROM phusion/baseimage:0.9.16
EXPOSE 9090
EXPOSE 60000
EXPOSE 60010
EXPOSE 60020
RUN apt-get update
RUN apt-get install -y curl wget
RUN echo "deb [arch=amd64] http://archive.cloudera.com/cdh4/ubuntu/lucid/amd64/cdh lucid-cdh4.3.0 contrib\n" \
         "deb-src http://archive.cloudera.com/cdh4/ubuntu/lucid/amd64/cdh lucid-cdh4.3.0 contrib" >> /etc/apt/sources.list.d/cloudera.list
RUN apt-get update
RUN mkdir /usr/local/java && \
    wget --no-cookies \
    --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz" \
    -O /tmp/jdk-7-linux-x64.tar.gz && \
    tar xvf /tmp/jdk-7-linux-x64.tar.gz --strip-components=1 -C /usr/local/java
ENV JAVA_HOME /usr/local/java
ENV PATH $PATH:$JAVA_HOME/bin
RUN java -version
RUN echo "Package: *\n" \
    "Pin: release o=Cloudera, l=Cloudera\n" \
    "Pin-Priority: 501" >> /etc/apt/preferences.d/cloudera.pref
RUN curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -
RUN apt-get install -y --force-yes hbase hbase-master hbase-thrift
RUN mkdir /hadoop-data
RUN chown hbase:hbase /hadoop-data
ADD etc/ /etc
ADD usr/ /usr

