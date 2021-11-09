FROM golang:1.17-alpine

ENV IP    0.0.0.0
ENV PEERPORT    4722
ENV APIPORT    4723
ENV BASEDIR    /home/quorum
ENV PEERNAME    peer
ENV DEBUG    true

RUN apk add --no-cache --update \
        bash \
        git && \
        git clone https://github.com/rumsystem/quorum.git /tmp/quorum && \
        mv /tmp/quorum /go/src/ && \
        rm -rf /tmp/quorum && \
        chmod a+x /go/src/quorum/scripts/build.sh && \
        mkdir /home/quorum 
        
WORKDIR /go/src/quorum

RUN ./scripts/build.sh
RUN echo "#!/bin/bash \n ./dist/linux_amd64/quorum -peername ${PEERNAME} -listen /ip4/${IP}/tcp/${PEERPORT} -apilisten ${IP}:${APIPORT} -peer /ip4/94.23.17.189/tcp/10666/p2p/16Uiu2HAmGTcDnhj3KVQUwVx8SGLyKBXQwfAxNayJdEwfsnUYKK4u,/ip4/132.145.109.63/tcp/10666/p2p/16Uiu2HAmTovb8kAJiYK8saskzz7cRQhb45NRK5AsbtdmYsLfD3RM -configdir ${BASEDIR}/peerConfig -datadir ${BASEDIR}/peerData -keystoredir ${BASEDIR}/keystore -debug ${DEBUG}" > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
# RUN go install -v ./...

EXPOSE ${PEERPORT}/tcp
EXPOSE ${APIPORT}/tcp

CMD ["./entrypoint.sh"]