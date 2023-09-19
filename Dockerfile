# Build grepcidr from source as not available from alpine repos
FROM alpine AS build
RUN apk add --no-cache g++ make
ADD http://www.pc-tools.net/files/unix/grepcidr-2.0.tar.gz /build/grepcidr-2.0.tar.gz
WORKDIR /build
RUN tar xzf grepcidr-2.0.tar.gz \
    && cd grepcidr-2.0 \
    && make \
    && make install

# Actual image
FROM alpine

RUN apk add --no-cache curl whois bind-tools mtr jq ipcalc nmap nmap-ncat aha bash ncurses
COPY --from=build /usr/local/bin/grepcidr /usr/local/bin/grepcidr

RUN mkdir -p /app
RUN curl "https://raw.githubusercontent.com/arbal/asn/master/asn" > /app/asn
RUN chmod 0755 /app/asn

EXPOSE 49200/tcp
ENTRYPOINT ["/app/asn"]
CMD ["-l", "0.0.0.0"]