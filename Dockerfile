#
# Copyright (c) 2001-2018 Genoud Magloire
# All rights reserved.
#
# author: Genoud Magloire (mailto:magloiredjatio@gmail.com)
#

FROM alpine:3.8

LABEL maintainer="magloiredjatio@gmail.com" \
    provider="Genoud Magloire"

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

ENV JAVA_VERSION="1.8.0_181"

#ENV JAVA_HOME="/usr/local/jdk${JAVA_VERSION}"

ENV JAVA_HOME="/opt/java/current"

ENV ANT_OPTS="-Xmx256M"

ENV ANT_HOME="/usr/local/ant-1.10.5"

ENV PATH="${PATH}:${JAVA_HOME}/bin:${ANT_HOME}/bin"

RUN apk add --no-cache bash

RUN apk add --update nodejs nodejs-npm

RUN apk add paxctl

RUN mkdir -p /opt/java

# ADD resources/jdk*.tar.gz /usr/local/
RUN wget --tries=3 \
        --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz \
        -O /tmp/jdk-8u181.tar.gz \
    && tar -zxf /tmp/jdk-8u181.tar.gz -C /opt/java

RUN ln -s /opt/java/jdk1.8.0_181 /opt/java/current

RUN ls -l /opt/java/jdk1.8.0_181/bin

#RUN sh /etc/profile.d/java.sh





RUN echo $PATH
RUN ls  -l $JAVA_HOME/bin
RUN java -version
#Install PMD

RUN wget https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.7.0/pmd-bin-6.7.0.zip \
        -O /tmp/pmd-bin-6.7.0.zip
RUN mkdir /usr/local/pmd-bin-6.7.0
RUN unzip /tmp/pmd-bin-6.7.0.zip -d /usr/local/pmd-bin-6.7.0
RUN alias pmd="/usr/local/pmd-bin-6.7.0/pmd-bin-6.7.0/bin/run.sh pmd"

#Install ANT

RUN wget http://www-eu.apache.org/dist//ant/binaries/apache-ant-1.10.5-bin.tar.gz \
        -O /tmp/apache-ant.tar.gz 
RUN mkdir /usr/local/ant-1.10.5
RUN tar xvfz  /tmp/apache-ant.tar.gz  -C /usr/local/ant-1.10.5 --strip-components 1

RUN ant -version


# ADD resources/sfdx*.tar.gz /usr/local/
RUN wget --tries=3 \
        https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz \
        -O /tmp/sfdx.tar.gz 

RUN mkdir sfdx 

RUN tar xJf /tmp/sfdx.tar.gz -C sfdx --strip-components 1

RUN ./sfdx/install


# Find avaliable downloads
# curl -s http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html | \
#        awk "/downloads\['/ && ! /demos/ && /\['files'\]\['jdk/"