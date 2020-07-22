# ASN Lookup Tool (Bash)

## Description

ASN/IPv4/IPv6/Prefix lookup tool. Uses [Team Cymru's whois service](https://team-cymru.com/community-services/ip-asn-mapping/) for data.

## Installation

To download the **asn** script from your shell:

`curl https://raw.githubusercontent.com/nitefood/asn/master/asn > asn && chmod +x asn`

After that, you can use the script by running `./asn`.

## Usage

* `asn <ASnumber>` -- _to lookup matching ASN data. Supports "as123" and "123" formats (case insensitive)_
* `asn <IPv4/IPv6>` -- _to lookup matching route(4/6) and ASN data_
* `asn <ROUTE>` -- _to lookup matching ASN data_
* `asn <host.name.tld>` -- _to lookup matching IP(v4/v6), route and ASN data (supports multiple IPs - e.g. DNS RR)_

## Thanks

This script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!