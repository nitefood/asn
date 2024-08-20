FROM alpine:3.20.2

ENV IQS_TOKEN ""
ENV IPINFO_TOKEN ""
ENV CLOUDFLARE_TOKEN ""

# - Prepare the config directory
# - Create the entrypoint script that writes the API tokens to the config files
# - Install prerequisite packages
RUN mkdir -p /etc/asn && \
	chown nobody:nobody /etc/asn/ && \
    printf '%s\n' '#!/usr/bin/env bash' \
    '[[ -n "$IQS_TOKEN" ]] 			&& echo "$IQS_TOKEN" > /etc/asn/iqs_token' \
	'[[ -n "$IPINFO_TOKEN" ]] 		&& echo "$IPINFO_TOKEN" > /etc/asn/ipinfo_token' \
	'[[ -n "$CLOUDFLARE_TOKEN" ]] 	&& echo "$CLOUDFLARE_TOKEN" > /etc/asn/cloudflare_token' \
    'exec "$@"' > /entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    apk update && \
    apk add --no-cache aha bash bind-tools coreutils curl grepcidr3 ipcalc jq mtr ncurses nmap nmap-ncat whois

COPY asn /bin/asn
RUN chmod 0755 /bin/asn

# Start the service by default
USER nobody
EXPOSE 49200/tcp
ENTRYPOINT ["/entrypoint.sh", "/bin/asn"]
CMD ["-l", "0.0.0.0"]
