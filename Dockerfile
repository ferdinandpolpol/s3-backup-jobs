FROM postgres:9.6

RUN apt-get update \
  && apt-get install -y python-pip lrzip

RUN pip install awscli

COPY backup-forever.sh /backup-forever.sh
COPY backup.sh /backup.sh

CMD /backup-forever.sh
