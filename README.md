# ASN Lookup Tool (Bash)

## Description

ASN/IPv4/IPv6/Prefix/ASPath lookup tool.

The script will perform an AS path trace (using [mtr](https://github.com/traviscross/mtr) in raw mode and retrieving AS data from the results) for single IPs or DNS results, optionally reporting detailed data for each hop, such as organization/network name, geographic location, etc. (screenshots below).

The script uses the [Team Cymru](https://team-cymru.com/community-services/ip-asn-mapping/) and the [Prefix WhoIs Project](https://pwhois.org/) services for data.

---

## Screenshots

### Generic usage ###

* _IPv4 lookup_

![asn](https://user-images.githubusercontent.com/24555810/92062672-8c6db280-ed99-11ea-89f8-59babb6f84c5.png)

* _IPv6 lookup_

![asn](https://user-images.githubusercontent.com/24555810/92062671-8bd51c00-ed99-11ea-9433-be0afb3d5375.png)

* _Autonomous system number lookup_

![asn](https://user-images.githubusercontent.com/24555810/92062669-8bd51c00-ed99-11ea-882e-3580f9228966.png)

* _Hostname lookup_

![asn](https://user-images.githubusercontent.com/24555810/92062668-8b3c8580-ed99-11ea-896e-5585c97d3d4a.png)

### AS Path tracing ###

* _ASPath trace to www.github.com_

![asn-tracepath](https://user-images.githubusercontent.com/24555810/92062667-8b3c8580-ed99-11ea-949a-e26d2dcf63e8.png)

* _Detailed ASPath trace to www.github.com_

![asn-tracepath](https://user-images.githubusercontent.com/24555810/91781037-9658af80-ebf9-11ea-8f9d-af587a701a7b.png)

---

## Installation

To download the **asn** script from your shell:

`curl https://raw.githubusercontent.com/nitefood/asn/master/asn > asn && chmod +x asn`

After that, you can use the script by running `./asn`.

## Usage

* `asn <ASnumber>` -- _to lookup matching ASN data. Supports "as123" and "123" formats (case insensitive)_
* `asn [-n|-d] <IPv4/IPv6>` -- _to lookup matching route(4/6) and ASN data_
* `asn [-n|-d] <host.name.tld>` -- _to lookup matching IP(v4/v6), route and ASN data (supports multiple IPs - e.g. DNS RR)_
* `asn <ROUTE>` -- _to lookup matching ASN data_

Detailed prefix info reporting can be turned on by passing the `[-d|--detailed]` command line switch. This will enable querying the public [pWhois server](https://pwhois.org/server.who) for every hop in the mtr trace, and its output will be displayed as a "tree" below the hop data, in addition to Team Cymru's server output (which only reports the AS name that the organization originating the prefix gave to its autonomous system number). This can be useful to figure out more details regarding the organization's name, the prefix' intended designation, and even (to a certain extent) its geographical scope.

The script will attempt a generic `whois` lookup during traces when Team Cymru and pWhois have no info about the IP address or prefix. This usually happens for IXP and PNI prefixes, and will give better insight into the path taken by packets.

Geolocation data is taken from pWhois.

AS path tracing is enabled by default for all lookups. In case of multiple IP results, the script will trace the first IP. Tracing can be disabled by passing the `[-n|--notrace]` command line switch.

## Thanks

This script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!
