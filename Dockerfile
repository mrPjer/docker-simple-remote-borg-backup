FROM debian:stretch-slim

RUN touch /var/log/cron.log && \
    mkdir data && \
    apt update && \
    apt install -y \
        borgbackup \
        cron \
        openssh-client && \
    rm -rf /var/lib/apt/lists/*

COPY runbackup.sh .
COPY crontab /etc/cron.d/run-backup
RUN chmod 0644 /etc/cron.d/run-backup

CMD ./dumpvars.sh && cron && ./runbackup.sh && tail -f /var/log/cron.log
