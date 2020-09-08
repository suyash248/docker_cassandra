FROM adoptopenjdk:8-jre-hotspot-bionic

RUN mkdir -p /var/lib/cassandra && mkdir -p /var/log/cassandra

ENV CASSANDRA_HOME="/usr/lib/cassandra"

ENV PATH $CASSANDRA_HOME/bin:$PATH
ADD https://archive.apache.org/dist/cassandra/1.2.5/apache-cassandra-1.2.5-bin.tar.gz "/usr/lib/"

WORKDIR /usr/lib/
RUN tar -xzf apache-cassandra-1.2.5-bin.tar.gz 
RUN mv /usr/lib/apache-cassandra-1.2.5 /usr/lib/cassandra


RUN chmod +x "${CASSANDRA_HOME}/bin/cassandra"
RUN chmod +x "/var/lib/cassandra"

WORKDIR "${CASSANDRA_HOME}/bin"

RUN sed -i "s/JVM_OPTS -Xss180k/JVM_OPTS -Xss256k/g" "${CASSANDRA_HOME}/conf/cassandra-env.sh"

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /docker-entrypoint.sh # backwards compat
WORKDIR /usr/local/bin/
RUN chmod +x "docker-entrypoint.sh"

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 7000 7001 7199 9042 9160

CMD ["cassandra", "-f"]

