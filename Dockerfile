FROM alpine

RUN apk add --update \
   python \
   lrzip \
   py-pip \
   docker \
  && pip install awscli \ 
  && rm -fr /var/cache/apk/*
#RUN apt-get update \
#  && apt-get install -y docker.io python-pip lrzip


COPY backup-forever.sh /backup-forever.sh
COPY backup.sh /backup.sh

CMD /backup-forever.sh
