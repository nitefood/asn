# ASN Lookup Tool (Bash)

## Description

ASN/IPv4/IPv6/Prefix/ASPath lookup tool.

The script will perform an AS path trace (using [mtr](https://github.com/traviscross/mtr) in raw mode and retrieving AS data from the results) for single IPs or DNS results, optionally reporting detailed data for each hop, such as organization/network name, geographic location, etc. (screenshots below).

The script uses the [Team Cymru](https://team-cymru.com/community-services/ip-asn-mapping/) and the [Prefix WhoIs Project](https://pwhois.org/) services for data.

## Screenshots

---
_Generic usage_

![asn](https://user-images.githubusercontent.com/24555810/88291624-d1152100-ccf8-11ea-93de-5f11eee8e2f5.png)

---

_Example ASPath trace to www.github.com_

![asn-tracepath](https://user-images.githubusercontent.com/24555810/91781380-783f7f00-ebfa-11ea-93e6-97cc65c761a5.png)

---

_Example detailed ASPath trace to www.github.com_

![asn-tracepath](https://user-images.githubusercontent.com/24555810/91781037-9658af80-ebf9-11ea-8f9d-af587a701a7b.png)


## Installation

To download the **asn** script from your shell:

`curl https://raw.githubusercontent.com/nitefood/asn/master/asn > asn && chmod +x asn`

After that, you can use the script by running `./asn`.

## Usage

* `asn <ASnumber>` -- _to lookup matching ASN data. Supports "as123" and "123" formats (case insensitive)_
* `asn <IPv4/IPv6>` -- _to lookup matching route(4/6) and ASN data_
* `asn <ROUTE>` -- _to lookup matching ASN data_
* `asn <host.name.tld>` -- _to lookup matching IP(v4/v6), route and ASN data (supports multiple IPs - e.g. DNS RR)_

Detailed prefix info reporting can be turned on by passing the `[-d|--detailed]` command line switch. This will enable querying the public [pWhois server](https://pwhois.org/server.who) for every hop in the mtr trace, and its output will be displayed as a "tree" below the hop data, in addition to Team Cymru's server output (which only reports the AS name that the organization originating the prefix gave to its autonomous system number). This can be useful to figure out more details regarding the organization's name, the prefix' intended designation, and even (to a certain extent) its geographical scope.

AS path tracing is enabled by default for lookup results involving a single IP address. This can be disabled by passing the `[-n|--notrace]` command line switch.

## Thanks

This script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!
