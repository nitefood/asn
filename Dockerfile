FROM alpine:3.18.5

ENV IQS_TOKEN ""

# - Prepare the config directory
# - Create the entrypoint script that writes the IQS token to the config file
# - Install prerequisite packages
RUN mkdir -p /etc/asn && \
    touch /etc/asn/iqs_token && \
    chown nobody:nobody /etc/asn/iqs_token && \
    echo -e "#!/bin/sh\nif [ -n \"\$IQS_TOKEN\" ]; then echo \"\$IQS_TOKEN\" > /etc/asn/iqs_token; fi\nexec \"\$@\"" > /entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    apk update && \
    apk add -X https://dl-cdn.alpinelinux.org/alpine/v3.19/community grepcidr3 && \
    apk add --no-cache aha bash bind-tools coreutils curl ipcalc jq mtr ncurses nmap nmap-ncat whois

COPY asn /bin/asn
RUN chmod 0755 /bin/asn

# Start the service by default
USER nobody
EXPOSE 49200/tcp
ENTRYPOINT ["/entrypoint.sh", "/bin/asn"]
CMD ["-l", "0.0.0.0"]
