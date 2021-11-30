FROM golang:1.17-alpine

ENV IP    0.0.0.0
ENV CERTIPS    default
ENV PEERPORT    4722
ENV APIPORT    4723
ENV BASEDIR    /home/quorum
ENV PEERNAME    peer
ENV DEBUG    true
ENV RUM_KSPASSWD    default-password-for-test-only

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

WORKDIR /home/quorum
RUN echo $'#!/bin/bash \nif [ "${CERTIPS}" = "default" ] ; then \n/go/src/quorum/dist/linux_amd64/quorum -peername ${PEERNAME} -listen /ip4/${IP}/tcp/${PEERPORT} -apilisten ${IP}:${APIPORT} -peer /ip4/94.23.17.189/tcp/10666/p2p/16Uiu2HAmGTcDnhj3KVQUwVx8SGLyKBXQwfAxNayJdEwfsnUYKK4u,/ip4/132.145.109.63/tcp/10666/p2p/16Uiu2HAmTovb8kAJiYK8saskzz7cRQhb45NRK5AsbtdmYsLfD3RM -configdir ${BASEDIR}/peerConfig -datadir ${BASEDIR}/peerData -keystoredir ${BASEDIR}/keystore -debug ${DEBUG} ;\nelse /go/src/quorum/dist/linux_amd64/quorum -peername ${PEERNAME} -ips ${CERTIPS} -listen /ip4/${IP}/tcp/${PEERPORT} -apilisten ${IP}:${APIPORT} -peer /ip4/94.23.17.189/tcp/10666/p2p/16Uiu2HAmGTcDnhj3KVQUwVx8SGLyKBXQwfAxNayJdEwfsnUYKK4u,/ip4/132.145.109.63/tcp/10666/p2p/16Uiu2HAmTovb8kAJiYK8saskzz7cRQhb45NRK5AsbtdmYsLfD3RM -configdir ${BASEDIR}/peerConfig -datadir ${BASEDIR}/peerData -keystoredir ${BASEDIR}/keystore -debug ${DEBUG} ;\nfi' > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

EXPOSE ${PEERPORT}/tcp
EXPOSE ${APIPORT}/tcp

ENTRYPOINT ["./entrypoint.sh"]
