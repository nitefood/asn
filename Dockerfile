FROM alpine:20230901

ARG IQS_TOKEN
RUN if [ -n "$IQS_TOKEN" ]; then mkdir -p /etc/asn && echo "$IQS_TOKEN" > /etc/asn/iqs_token; fi

# Install prerequisite packages
RUN	apk update && apk add --no-cache bash ncurses nmap nmap-ncat mtr aha curl whois grepcidr3 coreutils ipcalc bind-tools jq
COPY asn /bin/asn
RUN chmod 0755 /bin/asn

# Start the service by default
USER nobody
EXPOSE 49200/tcp
ENTRYPOINT ["/bin/asn"]
CMD ["-l", "0.0.0.0"]
