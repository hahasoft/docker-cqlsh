FROM alpine:3.9

ARG TZ='Asia/Bangkok'

ENV CQLSH_VERSION=5.0.5
ENV DEFAULT_TZ ${TZ}

RUN apk add --no-cache --update curl bash  python  py-pip tzdata \
    && cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime \  
	&& pip install --no-cache-dir install cqlsh==$CQLSH_VERSION \
	&& mkdir /root/.cassandra \
    && rm -rf /var/cache/apk/* && rm -rf /usr/share/zoneinfo

COPY ["cqlshrc", "/root/.cassandra/cqlshrc"]

ENTRYPOINT ["bash"]