# ASN Lookup Tool (Bash)

## Description

ASN / RPKI validity / BGP stats / IPv4v6 / Prefix / ASPath / Organization / IP reputation lookup tool.

This script serves the purpose of having a quick OSINT command line tool at disposal when investigating network data, which can come in handy in incident response scenarios as well.

Features:

- It will perform an **AS path trace** (using [mtr](https://github.com/traviscross/mtr) in raw mode and retrieving AS data from the results) for single IPs or DNS results, optionally reporting detailed data for each hop, such as RPKI ROA validity, organization/network name, geographic location, etc.
- It will attempt to lookup all relevant **abuse contacts** for any given IP or prefix.
- It will perform **RPKI validity** lookups for every possible IP. Data is validated against [RIPE RPKI Validator](https://rpki-validator.ripe.net/). For path traces, the tool will match each hop's ASN/Prefix pair (retrieved from the Prefix Whois public server) with relevant published RPKI ROAs. In case of origin AS mismatch or unallowed more-specific prefixes, it will warn the user of a potential **route leak / BGP hijack** along with the offending AS in the path (requires `-d` option, see below for usage info).
  - *Read more about BGP hijkacking [here](https://en.wikipedia.org/wiki/BGP_hijacking).*
  - *Read more about RPKI [here](https://en.wikipedia.org/wiki/Resource_Public_Key_Infrastructure), [here](https://blog.cloudflare.com/rpki/), or [here](https://www.ripe.net/manage-ips-and-asns/resource-management/certification).*
- It will also perform **IP reputation** lookups (especially useful when investigating foreign IPs from log files).
- It is also possible to search by **organization name** in order to retrieve a list of IPv4/6 network ranges related to a given company. A multiple choice menu will be presented if more than one organization matches the search query.

Screenshots for every lookup option are below.

The script uses the following services for data retrieval:
* [Team Cymru](https://team-cymru.com/community-services/ip-asn-mapping/)
* [The Prefix WhoIs Project](https://pwhois.org/)
* [ipify](https://www.ipify.org/)
* [RIPEStat](https://stat.ripe.net/)
* [RIPE RPKI Validator](https://rpki-validator.ripe.net/)
* [Auth0 Signals](https://auth0.com/signals)

Requires Bash v4.2+. Tested on: 

* Linux
* FreeBSD
* Windows (WSL2, Cygwin)
* MacOS *(thanks [Antonio Prado](https://github.com/Antonio-Prado))*

---

## Screenshots

### Generic usage ###

* _IPv4 lookup_

![ipv4lookup](https://user-images.githubusercontent.com/24555810/96518776-dc320b80-126b-11eb-9fb8-cfc874be09b0.png)

* _IPv4 lookup (bad reputation IP)_

![ipv4badlookup](https://user-images.githubusercontent.com/24555810/96518877-1ef3e380-126c-11eb-8036-043a8d45aabc.png)

* _IPv6 lookup_

![ipv6lookup](https://user-images.githubusercontent.com/24555810/96518993-4f3b8200-126c-11eb-97c4-2d5d89763fe6.png)

* _Autonomous system number lookup with BGP stats_

![asnlookup](https://user-images.githubusercontent.com/24555810/95674499-e475b100-0bb0-11eb-89db-a670442462cf.png)

* _Hostname lookup_

![hostnamelookup](https://user-images.githubusercontent.com/24555810/96519069-7bef9980-126c-11eb-92a3-6270c1b863cf.png)

### AS Path tracing ###

* _ASPath trace to www.github.com_

![pathtrace](https://user-images.githubusercontent.com/24555810/96519328-07692a80-126d-11eb-83f8-32e8ae5c5bfd.png)

* _Detailed ASPath trace to www.github.com (with unannounced IXP prefix in the path at hop #11)_

![detailed_pathtrace](https://user-images.githubusercontent.com/24555810/96520008-71360400-126e-11eb-8cc7-27be900ba968.png)

### Network search by organization ###

* _Organization search for "github"_

![search_by_org](https://user-images.githubusercontent.com/24555810/96520260-f7eae100-126e-11eb-8987-52b97c75faaf.png)

---

## Installation

### Prerequisite packages

Some packages are required for full functionality.

* On Debian/Ubuntu-based Linux distributions, you can install them with:

  `apt -y install curl whois bind9-host mtr-tiny jq ipcalc`

* On MacOS, you can install them using [Homebrew](https://brew.sh) with:

  `brew install bash coreutils curl whois mtr jq ipcalc && brew link mtr`

### Script download

Afterwards, to download the **asn** script from your shell:

`curl https://raw.githubusercontent.com/nitefood/asn/master/asn > asn && chmod +x asn`

You can then use the script by running `./asn`.

### IP reputation API token

The script will perform anonymous IPv4/v6 IP reputation lookups without the need for an API token, using the [Auth0 Signals API](https://auth0.com/signals/).

Nevertheless, it's strongly recommended to [sign up](https://auth0.com/signals/api/signup) for their service (it's free) and get an API token, which will raise the daily query quota from 100 hits to 40000 hits.
Once obtained, the api token should be written to the `$HOME/.asn/signals_token` file.
In order to do so, you can use the following command:

`TOKEN="<your_token_here>"; mkdir "$HOME/.asn/" && echo "$TOKEN" > "$HOME/.asn/signals_token" && chmod -R 600 "$HOME/.asn/"`

`asn` will pick up your token on the next run, and use it to query the Signals API.

## Usage

* `asn <ASnumber>` -- _to lookup matching ASN and BGP announcements/neighbours data. Supports "as123" and "123" formats (case insensitive)_
* `asn [-n|-d] <IPv4/IPv6>` -- _to lookup matching route(4/6), IP reputation and ASN data_
* `asn [-n|-d] <host.name.tld>` -- _to lookup matching IP(v4/v6), route and ASN data (supports multiple IPs - e.g. DNS RR)_
* `asn <Route>` -- _to lookup matching ASN data for the given prefix_
* `asn <Organization Name>` -- _to search by company name and lookup network ranges exported by (or related to) the company_

Detailed hop info reporting and RPKI validation can be turned on by passing the `[-d|--detailed]` command line switch. This will enable querying the public [pWhois server](https://pwhois.org/server.who) and the [RIPE RPKI Validator](https://rpki-validator.ripe.net/) for every hop in the mtr trace. Relevant info will be displayed as a "tree" below the hop data, in addition to Team Cymru's server output (which only reports the AS name that the organization originating the prefix gave to its autonomous system number). This can be useful to figure out more details regarding the organization's name, the prefix' intended designation, and even (to a certain extent) its geographical scope. Furthermore, this will enable a warning whenever RPKI validation fails for one of the hops in the trace, indicating which AS in the path is wrongly announcing (as per current pWhois data) the hop prefix, indicating a potential route leak or BGP hijacking incident.

The script will attempt a best-effort, generic `whois` lookup when Team Cymru and pWhois have no info about the IP address or prefix. This usually happens for IXP and PNI prefixes, and will give better insight into the path taken by packets.

Geolocation and organization data is taken from pWhois, while IP reputation data is taken from [Auth0 Signals](https://auth0.com/signals/).

AS path tracing is enabled by default for all lookups. In case of multiple IP results, the script will trace the first IP. Tracing can be disabled by passing the `[-n|--notrace]` command line switch.

## Thanks

This script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!
