FROM alpine:3.15

ARG TZ='Asia/Bangkok'

ENV CQLSH_VERSION=5.0.5
ENV DEFAULT_TZ ${TZ}
ENV DSBULK_VERSION=1.8.0
# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN apk add --no-cache --update curl bash python2  tzdata openjdk8 zip kcat \
    && cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime \  
	&& echo $TZ > /etc/timezone && date \
	&& python -m ensurepip && rm -r /usr/lib/python*/ensurepip \
	&& pip install --no-cache-dir install cqlsh==$CQLSH_VERSION \	
	&& mkdir /root/.cassandra \		
    && mkdir /dsbulk && cd /dsbulk \
	&& curl -OL https://downloads.datastax.com/dsbulk/dsbulk-${DSBULK_VERSION}.tar.gz \
	&& tar -C /dsbulk --strip-components=1 -xzf dsbulk-${DSBULK_VERSION}.tar.gz \
	&& rm -f dsbulk-${DSBULK_VERSION}.tar.gz \
	&& rm -rf /var/cache/apk/* && rm -rf /usr/share/zoneinfo 
   
ENV PATH $PATH:/dsbulk/bin
	
COPY ["cqlshrc", "/root/.cassandra/cqlshrc"]

ENTRYPOINT ["bash"]
