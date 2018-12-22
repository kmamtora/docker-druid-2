FROM centos:7

MAINTAINER KM

ENV PATH=/apache-druid-0.13.0-incubating/bin:${PATH}

RUN yum update -y
RUN yum install sudo curl java-1.8.0-openjdk-devel tar perl-libwww-perl -y

COPY config/ /tmp/
# COPY config/common.runtime.properties /tmp/

RUN curl https://www-us.apache.org/dist/incubator/druid/0.13.0-incubating/apache-druid-0.13.0-incubating-bin.tar.gz -o apache-druid-0.13.0-incubating-bin.tar.gz 

RUN curl https://archive.apache.org/dist/zookeeper/zookeeper-3.4.11/zookeeper-3.4.11.tar.gz -o zookeeper-3.4.11.tar.gz

RUN tar -xvzf apache-druid-0.13.0-incubating-bin.tar.gz && \
	rm -f apache-druid-0.13.0-incubating-bin.tar.gz

RUN tar -xvzf zookeeper-3.4.11.tar.gz && \
	rm -f zookeeper-3.4.11.tar.gz && \
	mv zookeeper-3.4.11 apache-druid-0.13.0-incubating/zk

RUN mkdir apache-druid-0.13.0-incubating/quickstart/tutorial/conf/druid/_common/hadoop-xml
RUN mv /tmp/*.xml apache-druid-0.13.0-incubating/quickstart/tutorial/conf/druid/_common/hadoop-xml/
RUN mv /tmp/common.runtime.properties apache-druid-0.13.0-incubating/quickstart/tutorial/conf/druid/_common/

# Expose ports:
# - 8081: HTTP (coordinator)
# - 8082: HTTP (broker)
# - 8083: HTTP (historical)
# - 8090: HTTP (overlord)
# - 2181 2888 3888: ZooKeeper
EXPOSE 8081 8082 8083 2181 2888 3888 8090

CMD ["-c"]
