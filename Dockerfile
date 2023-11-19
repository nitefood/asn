FROM debian:12-slim

RUN apt update && \
    apt upgrade && \
    apt install -y --no-install-recommends \
      aha \
      bash \
      bind9-dnsutils \
      curl \
      grepcidr \
      ipcalc \
      jq \
      mtr-tiny \
      ncat \
      ncurses-bin \
      nmap \
      whois \
      netbase \
    && useradd --no-log-init -K UID_MIN=10000 -K GID_MIN=10000 user

RUN mkdir -p /app
COPY asn /app/asn
RUN chmod 0755 /app/asn

USER 10000
EXPOSE 49200/tcp
ENTRYPOINT ["/app/asn"]
CMD ["-l", "0.0.0.0"]
