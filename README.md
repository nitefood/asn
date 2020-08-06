# ASN Lookup Tool (Bash)

## Description

ASN/IPv4/IPv6/Prefix/ASPath lookup tool.

The script will perform an AS path trace (using [mtr](https://github.com/traviscross/mtr) in raw mode and retrieving AS data from the results) for single IPs or DNS results (screenshots below).

The script uses [Team Cymru's whois service](https://team-cymru.com/community-services/ip-asn-mapping/) for data.

## Screenshots

---
_Generic usage_

![asn](https://user-images.githubusercontent.com/24555810/88291624-d1152100-ccf8-11ea-93de-5f11eee8e2f5.png)

---

_Example ASPath trace to www.github.com_

![asn-tracepath](https://user-images.githubusercontent.com/24555810/89486372-365e1d00-d7a3-11ea-9f8b-3e8937d2f51e.png)


## Installation

To download the **asn** script from your shell:

`curl https://raw.githubusercontent.com/nitefood/asn/master/asn > asn && chmod +x asn`

After that, you can use the script by running `./asn`.

## Usage

* `asn <ASnumber>` -- _to lookup matching ASN data. Supports "as123" and "123" formats (case insensitive)_
* `asn <IPv4/IPv6>` -- _to lookup matching route(4/6) and ASN data_
* `asn <ROUTE>` -- _to lookup matching ASN data_
* `asn <host.name.tld>` -- _to lookup matching IP(v4/v6), route and ASN data (supports multiple IPs - e.g. DNS RR)_

AS path tracing is enabled by default for lookup results involving a single IP address. This can be disabled by passing the `[n|--notrace]` command line switch.

## Thanks

This script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!
