# ASN Lookup Tool (Bash)

## Description

ASN / BGP stats / IPv4v6 / Prefix / ASPath / Organization / IP reputation lookup tool.

This script serves the purpose of having a quick OSINT command line tool at disposal when investigating network data, which can come in handy in incident response scenarios as well.

- It will perform an AS path trace (using [mtr](https://github.com/traviscross/mtr) in raw mode and retrieving AS data from the results) for single IPs or DNS results, optionally reporting detailed data for each hop, such as organization/network name, geographic location, etc.

- It will also perform IP reputation lookups (especially useful when investigating foreign IPs from log files).

- It is also possible to search by _organization name_ in order to retrieve a list of IPv4/6 network ranges related to a given company. A multiple choice menu will be presented if more than one organization matches the search query.

Screenshots for every lookup option are below.

The script uses the following services for data retrieval:
* [Team Cymru](https://team-cymru.com/community-services/ip-asn-mapping/)
* [The Prefix WhoIs Project](https://pwhois.org/)
* [ipify](https://www.ipify.org/)
* [RIPE](https://stat.ripe.net/)
* [Auth0 Signals](https://auth0.com/signals)

Requires Bash v4.2+. Tested on Linux, FreeBSD, WSL (v2) and Cygwin.

---

## Screenshots

### Generic usage ###

* _IPv4 lookup_

![ipv4lookup](https://user-images.githubusercontent.com/24555810/95701899-1176a200-0c4b-11eb-9ca4-86de1eebaefb.png)

* _IPv4 lookup (bad reputation IP)_

![badipv4lookup](https://user-images.githubusercontent.com/24555810/95702521-cfe6f680-0c4c-11eb-9110-be82e9efbc82.png)

* _IPv6 lookup_

![ipv6lookup](https://user-images.githubusercontent.com/24555810/95702427-91513c00-0c4c-11eb-8ccb-614224bed15c.png)

* _Autonomous system number lookup with BGP stats_

![asnlookup](https://user-images.githubusercontent.com/24555810/95674499-e475b100-0bb0-11eb-89db-a670442462cf.png)

* _Hostname lookup_

![hostnamelookup](https://user-images.githubusercontent.com/24555810/92540333-83229100-f244-11ea-8d3f-2e21d6f04b3b.png)

### AS Path tracing ###

* _ASPath trace to www.github.com_

![pathtrace](https://user-images.githubusercontent.com/24555810/95675519-2b1ad980-0bb8-11eb-9888-478728c54064.png)

* _Detailed ASPath trace to www.github.com (with unannounced IXP prefix in the path at hop #11)_

![detailed_pathtrace](https://user-images.githubusercontent.com/24555810/95675487-f1e26980-0bb7-11eb-8c39-61582d1e7b1b.png)

### Network search by organization ###

* _Organization search for "github"_

![search_by_org](https://user-images.githubusercontent.com/24555810/95673393-4b429c80-0ba8-11eb-8703-8894c48e1638.png)

---

## Installation

### Prerequisite packages

Some packages are required for full functionality. On a Debian/Ubuntu machine, you can install them with:

`apt -y install curl whois bind9-host mtr-tiny jq ipcalc`

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

Detailed hop info reporting can be turned on by passing the `[-d|--detailed]` command line switch. This will enable querying the public [pWhois server](https://pwhois.org/server.who) for every hop in the mtr trace, and its output will be displayed as a "tree" below the hop data, in addition to Team Cymru's server output (which only reports the AS name that the organization originating the prefix gave to its autonomous system number). This can be useful to figure out more details regarding the organization's name, the prefix' intended designation, and even (to a certain extent) its geographical scope.

The script will attempt a best-effort, generic `whois` lookup when Team Cymru and pWhois have no info about the IP address or prefix. This usually happens for IXP and PNI prefixes, and will give better insight into the path taken by packets.

Geolocation and organization data is taken from pWhois, while IP reputation data is taken from [Auth0 Signals](https://auth0.com/signals/).

AS path tracing is enabled by default for all lookups. In case of multiple IP results, the script will trace the first IP. Tracing can be disabled by passing the `[-n|--notrace]` command line switch.

## Thanks

This script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!
