FROM mineichen/hadoop:2.6.0.0

ENV HIVE_VERSION 1.2.1 
ENV HIVE_HOME /usr/local/hive

RUN set -xe \
  && apk add --no-cache --virtual .build-deps \
                git \
                bash \
                gnupg \
                curl \
  && export GNUPGHOME="$(mktemp -d)" \
\
  && mkdir /root/build \
  && cd /root/build \
  && curl -fSL http://www-eu.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz -o hive.tar.gz \
  && curl -fSL http://www.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz.asc -o hive.tar.gz.asc \
  && curl -fSL http://www-eu.apache.org/dist/hive/KEYS -o hive.tar.gz.keys \
  && gpg --import hive.tar.gz.keys \ 
#  && gpg --verify hive.tar.gz.asc hive.tar.gz \ 
  && tar -zxf hive.tar.gz \
  && mkdir -p $HIVE_HOME \
  && mv apache-hive-${HIVE_VERSION}-bin/* $HIVE_HOME \
\
  && echo "Add Mysql-Support" \
  && curl -L 'https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.39.tar.gz' | tar xz \
  && cp mysql-connector-java-5.1.39/mysql-connector-java-5.1.39-bin.jar /usr/local/hive/lib/ \
\ 
  && echo "Cleanup" \ 
  && cd $HIVE_HOME \
  && rm -rf /root/build \
  && chown -R hive:supergroup . 

ENV HCAT_HOME=$HIVE_HOME/hcatalog
ENV PATH $PATH:/usr/local/hive/bin

WORKDIR $HIVE_HOME
