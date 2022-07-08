FROM alpine:3.9

ARG TZ='Asia/Bangkok'

ENV CQLSH_VERSION=5.0.5
ENV DEFAULT_TZ ${TZ}
ENV DSBULK_VERSION=1.8.0

RUN apk add --no-cache --update curl bash python py-pip tzdata openjdk8 zip \
    && cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime \  
	&& pip install --no-cache-dir install cqlsh==$CQLSH_VERSION \
	&& echo $TZ > /etc/timezone && date 
	&& mkdir /root/.cassandra \		
    && mkdir /dsbulk && cd /dsbulk \
	&& curl -OL https://downloads.datastax.com/dsbulk/dsbulk-${DSBULK_VERSION}.tar.gz \
	&& tar -C /dsbulk --strip-components=1 -xzf dsbulk-${DSBULK_VERSION}.tar.gz \
	&& && rm -f dsbulk-${DSBULK_VERSION}.tar.gz \
	&& rm -rf /var/cache/apk/* && rm -rf /usr/share/zoneinfo 
   
ENV PATH $PATH:/dsbulk/bin
	
COPY ["cqlshrc", "/root/.cassandra/cqlshrc"]
COPY ["run.sh", "/script/run.sh"]

ENTRYPOINT ["bash"]
