# ASN Lookup Tool (Bash)

## Description

ASN/IPv4/IPv6/Prefix/ASPath/Organization lookup tool.

The script will perform an AS path trace (using [mtr](https://github.com/traviscross/mtr) in raw mode and retrieving AS data from the results) for single IPs or DNS results, optionally reporting detailed data for each hop, such as organization/network name, geographic location, etc.

It is also possible to search for netblocks by _organization name_. A multiple choice menu will be presented if more than one organization ID matches the search query.

Screenshots for every lookup option are below.

The script uses the [Team Cymru](https://team-cymru.com/community-services/ip-asn-mapping/) and the [Prefix WhoIs Project](https://pwhois.org/) services for data.

Requires Bash v4+. Tested on Linux, FreeBSD, WSL (v2) and Cygwin.

---

## Screenshots

### Generic usage ###

* _IPv4 lookup_

![ipv4lookup](https://user-images.githubusercontent.com/24555810/92528238-b9eaae00-f228-11ea-875a-a44eff701f4d.png)

* _IPv6 lookup_

![ipv6lookup](https://user-images.githubusercontent.com/24555810/92528338-e69ec580-f228-11ea-9488-3f762c2d8582.png)

* _Autonomous system number lookup_

![asnlookup](https://user-images.githubusercontent.com/24555810/92260440-305d7800-eed8-11ea-8371-76c0a54d3b30.png)

* _Hostname lookup_

![hostnamelookup](https://user-images.githubusercontent.com/24555810/92540333-83229100-f244-11ea-8d3f-2e21d6f04b3b.png)

### AS Path tracing ###

* _ASPath trace to github.com_

![pathtrace](https://user-images.githubusercontent.com/24555810/92540382-b49b5c80-f244-11ea-87a8-9cf460ea192a.png)

* _Detailed ASPath trace to www.github.com_

![detailed_pathtrace](https://user-images.githubusercontent.com/24555810/92541428-46579980-f246-11ea-90da-3a24bdb5e833.png)

### Netblock search by organization ###

* _Organization search for company "github"_

![search_by_org](https://user-images.githubusercontent.com/24555810/92541547-a3534f80-f246-11ea-9f12-96b3aaabcd93.png)

---

## Installation

To download the **asn** script from your shell:

`curl https://raw.githubusercontent.com/nitefood/asn/master/asn > asn && chmod +x asn`

After that, you can use the script by running `./asn`.

## Usage

* `asn <ASnumber>` -- _to lookup matching ASN data. Supports "as123" and "123" formats (case insensitive)_
* `asn [-n|-d] <IPv4/IPv6>` -- _to lookup matching route(4/6) and ASN data_
* `asn [-n|-d] <host.name.tld>` -- _to lookup matching IP(v4/v6), route and ASN data (supports multiple IPs - e.g. DNS RR)_
* `asn <Route>` -- _to lookup matching ASN data for the given prefix_
* `asn <Organization Name>` -- _to search by company name and lookup netblocks (ORG-IDs) exported by such company_

Detailed hop info reporting can be turned on by passing the `[-d|--detailed]` command line switch. This will enable querying the public [pWhois server](https://pwhois.org/server.who) for every hop in the mtr trace, and its output will be displayed as a "tree" below the hop data, in addition to Team Cymru's server output (which only reports the AS name that the organization originating the prefix gave to its autonomous system number). This can be useful to figure out more details regarding the organization's name, the prefix' intended designation, and even (to a certain extent) its geographical scope.

The script will attempt a generic `whois` lookup during traces when Team Cymru and pWhois have no info about the IP address or prefix. This usually happens for IXP and PNI prefixes, and will give better insight into the path taken by packets.

Geolocation and organization data is taken from pWhois.

AS path tracing is enabled by default for all lookups. In case of multiple IP results, the script will trace the first IP. Tracing can be disabled by passing the `[-n|--notrace]` command line switch.

## Thanks

This script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!
