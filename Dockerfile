FROM alpine:3.6

MAINTAINER Alessandro Molari <alessandro.molari@yoroi.company> (alem0lars)

# == BASIC SOFTWARE ============================================================

RUN apk update \
 && apk upgrade

# == ENV / PARAMS ==============================================================

ENV MURMUR_USER murmur
ENV MURMUR_HOME /home/murmur

ENV MURMUR_CFG_FILE $MURMUR_HOME/murmur.cfg

ENV DEFAULT_WORKDIR /tmp
WORKDIR $DEFAULT_WORKDIR

# == USER ======================================================================

RUN adduser -D $MURMUR_USER -h $MURMUR_HOME -s /bin/bash

# == DEPENDENCIES ==============================================================

# == APP =======================================================================

RUN apk add --update --no-cache murmur

ADD dist/murmur.conf $MURMUR_CFG_FILE

EXPOSE 64738/tcp 64738/udp

# == LOGROTATE =================================================================

RUN apk add --update --no-cache logrotate

RUN mv /etc/periodic/daily/logrotate /etc/periodic/hourly/logrotate

ADD dist/logrotate.conf /etc/logrotate.d/murmur

# == RSYSLOG ===================================================================

RUN apk add --update --no-cache rsyslog

ADD dist/rsyslog.conf /etc/rsyslog.d/90-murmur.conf

# == SUPERVISORD ===============================================================

RUN apk add --update --no-cache supervisor

ADD dist/supervisord.ini /etc/supervisor.d/supervisord.ini

# == TOOLS (useful when inspecting the container) ==============================

RUN apk add --update --no-cache vim bash-completion

# == ENTRYPOINT ================================================================

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
