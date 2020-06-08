FROM docker.elastic.co/elasticsearch/elasticsearch:7.7.1

ENV PINYIN elasticsearch-analysis-pinyin-7.7.1.zip
ENV IK elasticsearch-analysis-ik-7.7.1.zip

COPY ${PINYIN} /tmp/
COPY ${IK} /tmp/

RUN mkdir plugins/pinyin && \
    unzip /tmp/${PINYIN} -d plugins/pinyin && \
    mkdir plugins/ik && \
    unzip /tmp/${IK} -d plugins/ik

RUN rm -rf /tmp/${PINYIN} && \
    rm -rf /tmp/${IK}

