FROM azul/zulu-openjdk-alpine:17-jre

ENV KAFKA_VERSION=3.6.1
ENV KAFKA_URL=https://www-eu.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.13-${KAFKA_VERSION}.tgz
ENV KAFKA_TEMP_FILE=/opt/kafka.tgz
ENV KAFKA_WORKDIR=/opt/kafka

ADD entrypoint.sh /opt/entrypoint.sh
ADD create_topics.sh /opt/create_topics.sh

RUN apk update && apk add bash && rm -rf /var/cache/apk/* \
 && chmod +x /opt/entrypoint.sh \
 && wget ${KAFKA_URL} -O ${KAFKA_TEMP_FILE} \
 && mkdir -p ${KAFKA_WORKDIR} \
 && tar -xzpf ${KAFKA_TEMP_FILE} --strip-components=1 -C ${KAFKA_WORKDIR} \
 && rm ${KAFKA_TEMP_FILE}  \
 && rm -rf ${KAFKA_WORKDIR}/bin/windows

ENV PATH ${PATH}:/opt/kafka/bin

WORKDIR /opt
ENTRYPOINT ["/opt/entrypoint.sh"]


