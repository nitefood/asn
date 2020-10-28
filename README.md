# ASN Lookup Tool (Bash)

## Description

ASN / RPKI validity / BGP stats / IPv4v6 / Prefix / ASPath / Organization / IP reputation lookup tool.

This script serves the purpose of having a quick OSINT command line tool at disposal when investigating network data, which can come in handy in incident response scenarios as well.

Features:

* It will lookup relevant Autonomous System information for any given AS number, including:
  * **Organization name**
  * **BGP statistics** (*neighbours count, originated v4/v6 prefix count*)
  * **Peering relationships** separated by type (*upstream/downstream/uncertain*), and sorted by observed *path count*, to give more reliable results (so for instance, the first few upstream peers are most likely to be transits).
  * **Announced prefixes** aggregated to the most relevant less-specific `INET(6)NUM` object (actual [LIR allocation](https://www.ripe.net/manage-ips-and-asns/db/support/documentation/ripe-database-documentation/rpsl-object-types/4-2-descriptions-of-primary-objects/4-2-4-description-of-the-inetnum-object)).

- It will perform an **AS path trace** (using [mtr](https://github.com/traviscross/mtr) in raw mode and retrieving AS data from the results) for single IPs or DNS results, optionally reporting detailed data for each hop, such as RPKI ROA validity, organization/network name, geographic location, etc.
- It will also detect **IXPs** (Internet Exchange Points) traversed during the trace, and highlight them for clarity.
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
* [PeeringDB](https://www.peeringdb.com/)
* [ipify](https://www.ipify.org/)
* [RIPEStat](https://stat.ripe.net/)
* [RIPE RPKI Validator](https://rpki-validator.ripe.net/)
* [Auth0 Signals](https://auth0.com/signals)

Requires Bash v4.2+. Tested on:

* Linux
* FreeBSD
* Windows (WSL2, Cygwin)
* MacOS *(thanks [Antonio Prado](https://github.com/Antonio-Prado) and Alessandro Barisone)*

---

## Screenshots

### Generic usage ###

* _IPv4 lookup_

![ipv4lookup](https://user-images.githubusercontent.com/24555810/96518776-dc320b80-126b-11eb-9fb8-cfc874be09b0.png)

* _IPv4 lookup (bad reputation IP)_

![ipv4badlookup](https://user-images.githubusercontent.com/24555810/96518877-1ef3e380-126c-11eb-8036-043a8d45aabc.png)

* _IPv6 lookup_

![ipv6lookup](https://user-images.githubusercontent.com/24555810/96518993-4f3b8200-126c-11eb-97c4-2d5d89763fe6.png)

* _Autonomous system number lookup with BGP stats, peering and prefix informations_

![asnlookup](https://user-images.githubusercontent.com/24555810/97374503-bf738480-18b8-11eb-8214-4cbcd39fd4fa.png)

* _Hostname lookup_

![hostnamelookup](https://user-images.githubusercontent.com/24555810/96519069-7bef9980-126c-11eb-92a3-6270c1b863cf.png)

### AS Path tracing ###

* _ASPath trace to www.github.com_

![pathtrace](https://user-images.githubusercontent.com/24555810/96940658-9b86fc00-14d0-11eb-8a46-e8dc373f2537.png)


* *ASPath trace traversing both an unannounced PNI prefix (FASTWEB->SWISSCOM at hop 11) and an IXP (SWISSCOM -> ROSTELECOM through DE-CIX at hop 14)*

![pathtrace_pni_ixp](https://user-images.githubusercontent.com/24555810/96941621-2e289a80-14d3-11eb-95b7-99c1bd3b2add.png)


* _Detailed ASPath trace to 8.8.8.8 traversing the Milan Internet Exchange (MIX) IXP peering LAN at hop 5_

![detailed_pathtrace](https://user-images.githubusercontent.com/24555810/96940972-7b0b7180-14d1-11eb-8132-456521123e6a.png)


### Network search by organization ###

* _Organization search for "github"_

![search_by_org](https://user-images.githubusercontent.com/24555810/96520260-f7eae100-126e-11eb-8987-52b97c75faaf.png)

---

## Installation

### Prerequisite packages

This script requires **BASH v4.2** or later. Some additional packages are also required for full functionality:

* **Debian/Ubuntu:**

  `apt -y install curl whois bind9-host mtr-tiny jq ipcalc grepcidr`

* **CentOS 7/8:**

  ```
  yum -y install curl whois bind-utils mtr jq perl && \
  rpm -ivh http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/grepcidr-2.0-1.el7.art.x86_64.rpm \
  https://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el7/en/x86_64/rpmforge/RPMS/ipcalc-0.41-1.el7.rf.x86_64.rpm
  ```

* **FreeBSD**:

  `env ASSUME_ALWAYS_YES=YES pkg install bash coreutils curl whois mtr jq ipcalc grepcidr`

* **MacOS** (using [Homebrew](https://brew.sh)):

  `brew install bash coreutils curl whois mtr jq ipcalc grepcidr && brew link mtr`

  *(Note for MacOS users: if `mtr` still can't be found after running the command above, [this](https://docs.brew.sh/FAQ#my-mac-apps-dont-find-usrlocalbin-utilities) may help to fix it)*

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

##### *Syntax*

* `asn <ASnumber>` -- _to lookup matching ASN and BGP announcements/neighbours data. Supports "as123" and "123" formats (case insensitive)_
* `asn [-n|-d] <IPv4/IPv6>` -- _to lookup matching route(4/6), IP reputation and ASN data_
* `asn [-n|-d] <host.name.tld>` -- _to lookup matching IP(v4/v6), route and ASN data (supports multiple IPs - e.g. DNS RR)_
* `asn <Route>` -- _to lookup matching ASN data for the given prefix_
* `asn [-o] <Organization Name>` -- _to search by company name and lookup network ranges exported by (or related to) the company_

##### *Path tracing and reputation*

- AS path tracing is enabled by default for all lookups. In case of multiple IP results, the script will trace the first IP, with a preference for IPv6 if possible on the user's host.
- Geolocation and organization data is taken from pWhois, while IP reputation data is taken from Auth0 Signals.
- Tracing can be disabled altogether by passing the `[-n|--notrace]` command line switch.

##### *Detailed mode (-d)*

- Detailed hop info reporting and RPKI validation can be turned on by passing the `[-d|--detailed]` command line switch. This will enable querying the public [pWhois server](https://pwhois.org/server.who) and the [RIPE RPKI Validator](https://rpki-validator.ripe.net/) for every hop in the mtr trace. Relevant info will be displayed as a "tree" below the hop data, in addition to Team Cymru's server output (which only reports the AS name that the organization originating the prefix gave to its autonomous system number). This can be useful to figure out more details regarding the organization's name, the prefix' intended designation, and even (to a certain extent) its geographical scope.

  Furthermore, this will enable a warning whenever RPKI validation fails for one of the hops in the trace, indicating which AS in the path is wrongly announcing (as per current pWhois data) the hop prefix, indicating a potential route leak or BGP hijacking incident.

##### *Organization search (-o)*

- The script will try to figure out if the input is an Organization name (i.e. if it doesn't look like an IP address, an AS number or a hostname).
  In order to force an organization search (for example for Orgs containing `.` in their name), pass the `[-o|--organization]` command line switch.

##### *IXP detection and unannounced prefixes*

- The script will detect [IXPs](https://en.wikipedia.org/wiki/Internet_exchange_point) traversed during path traces by matching them with [PeeringDB](https://www.peeringdb.com/)'s comprehensive dataset of IXP prefixes.
- The script will also attempt a best-effort, fallback generic `whois` lookup when Team Cymru, pWhois and PeeringDB have no info about the IP address or prefix. This is usually the case with some [PNI](https://en.wikipedia.org/wiki/Peering#Private_peering) prefixes, and will give better insight into the path taken by packets.

## Thanks

This script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!
