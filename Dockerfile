FROM openjdk:8u141-jdk

LABEL maintainer="javi@openbookpublishers.com"

ENV HANDLE_V 9.1.0
ENV PSQL_V 42.1.4
ENV MYSQL_V 5.1.44

EXPOSE 2461/tcp
EXPOSE 2461/udp
EXPOSE 80/tcp
EXPOSE 443/tcp

RUN apt-get update && apt-get install -y --no-install-recommends curl

WORKDIR /usr/src

RUN export DOWNHOME="$(mktemp -d)"

# download handle.net software
RUN  curl -fsSL -o ${DOWNHOME}/handle.tar.gz \
    "http://www.handle.net/hnr-source/handle-${HANDLE_V}-distribution.tar.gz"; \
  tar -xzf ${DOWNHOME}/handle.tar.gz --strip-components=1 -C /usr/src/

# download mysql JDBC driver
RUN curl -fsSL -o ${DOWNHOME}/mysql.tar.gz \
    "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_V}.tar.gz"; \
  tar -xzf ${DOWNHOME}/mysql.tar.gz -C lib --strip-components=1 \
    "mysql-connector-java-${MYSQL_V}/mysql-connector-java-${MYSQL_V}-bin.jar"

# download psql JDBC driver
RUN curl -fsSL -o lib/postgresql-${PSQL_V}.jar \
     "https://jdbc.postgresql.org/download/postgresql-${PSQL_V}.jar"
RUN rm -rf ${DOWNHOME}

VOLUME /hs

CMD ["./bin/hdl-server", "/hs"]
