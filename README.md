# ASN Lookup Tool and Traceroute Server



*Quick jump:*

* [Description](#description)
* [Screenshots](#screenshots)
* [Installation](#installation)
* [Usage (as a command line tool)](#usage)
* [Usage (as a lookup & traceroute server)](#running-lookups-from-the-browser)



## Description

ASN / RPKI validity / BGP stats / IPv4v6 / Prefix / ASPath / Organization / IP reputation & geolocation lookup tool / Web traceroute server.

This script serves the purpose of having a quick OSINT **command line tool** at disposal when investigating network data, which can come in handy in incident response scenarios as well.

It can also be used as a **web-based traceroute server**, by running it in listening mode and launching lookups and traces from a local or remote browser (via a bookmarklet or custom search engine) or terminal (via `curl`, `elinks` or similar tools). Click [here](#running-lookups-from-the-browser) for more information about  server mode functionality.

#### Features:

* It will lookup relevant Autonomous System information for any given AS number, including:
  * **Organization name**
  * **IXP Presence** (*Internet Exchange facilities where the AS is present*)
  * **BGP statistics** (*neighbours count, originated v4/v6 prefix count*)
  * **Peering relationships** separated by type (*upstream/downstream/uncertain*), and sorted by observed *path count*, to give more reliable results (so for instance, the first few upstream peers are most likely to be transits).
  * **Announced prefixes** aggregated to the most relevant less-specific `INET(6)NUM` object (actual [LIR allocation](https://www.ripe.net/manage-ips-and-asns/db/support/documentation/ripe-database-documentation/rpsl-object-types/4-2-descriptions-of-primary-objects/4-2-4-description-of-the-inetnum-object)).

- It will perform an **AS path trace** (using [mtr](https://github.com/traviscross/mtr) and retrieving AS data from the results) for single IPs or DNS results, optionally reporting detailed data for each hop, such as RPKI ROA validity, organization/network name, geographic location, etc.
- It will detect **IXPs** (Internet Exchange Points) traversed during the trace, and highlight them for clarity.
- It will attempt to lookup all relevant **abuse contacts** for any given IP or prefix.
- It will perform **RPKI validity** lookups for every possible IP. Data is validated using the [RIPEStat RPKI validation API](https://stat.ripe.net/docs/data_api#rpki-validation). For path traces, the tool will match each hop's ASN/Prefix pair (retrieved from the Prefix Whois public server) with relevant published RPKI ROAs. In case of origin AS mismatch or unallowed more-specific prefixes, it will warn the user of a potential **route leak / BGP hijack** along with the offending AS in the path (requires `-d` option, see below for usage info).
  - *Read more about BGP hijkacking [here](https://en.wikipedia.org/wiki/BGP_hijacking).*
  - *Read more about RPKI [here](https://en.wikipedia.org/wiki/Resource_Public_Key_Infrastructure), [here](https://blog.cloudflare.com/rpki/), or [here](https://www.ripe.net/manage-ips-and-asns/resource-management/certification).*
- It will perform **IP geolocation** lookups according to the logic described [below](#geolocation).
- It will perform **IP reputation, noise classification** and in-depth **threat analysis** reporting (especially useful when investigating foreign IPs from log files).
- It will perform **IP type identification** (*Anycast IP/Mobile network/Proxy host/Hosting provider/IXP prefix*) for target IPs and individual trace hops.
  - It will also identify **bogon** addresses being traversed and classify them according to the relevant RFC (Private address space/CGN space/Test address/link-local/reserved/etc.)
- It is possible to search by **organization name** in order to retrieve a list of IPv4/6 network ranges related to a given company. A multiple choice menu will be presented if more than one organization matches the search query.
- It is possible to search for **ASNs matching a given name**, in order to map the ASNs for a given organization.

Screenshots for every lookup option are below.

The script uses the following services for data retrieval:
* [Team Cymru](https://team-cymru.com/community-services/ip-asn-mapping/)
* [The Prefix WhoIs Project](https://pwhois.org/)
* [PeeringDB](https://www.peeringdb.com/)
* [ipify](https://www.ipify.org/)
* [RIPEStat](https://stat.ripe.net/)
* [RIPE IPmap](https://ipmap.ripe.net/)
* [ip-api](https://ip-api.com/)
* [StopForumSpam](https://www.stopforumspam.com/)
* [IP Quality Score](https://www.ipqualityscore.com)
* [GreyNoise](https://greynoise.io)

It also provides hyperlinks (in [server](#running-lookups-from-the-browser) mode) to the following external services when appropriate:

* [HE.net](https://bgp.he.net)
* [BGPView](https://bgpview.io)
* [IPInfo.io](https://ipinfo.io)
* [Host.io](https://host.io)

Requires Bash v4.2+. Tested on:

* Linux
* FreeBSD
* Windows (WSL2, Cygwin)
* MacOS *(thanks [Antonio Prado](https://github.com/Antonio-Prado) and Alessandro Barisone)*

---

## Screenshots

### Generic usage ###

* _IPv4 lookup with IP type detection (Anycast, Hosting/DC) and classification as known good_

![ipv4lookup](https://user-images.githubusercontent.com/24555810/117334574-72412280-ae9a-11eb-86d8-b57a4d4291f0.png)

* _IPv4 lookup (bad reputation IP) with threat analysis and scoring_

![ipv4badlookup](https://user-images.githubusercontent.com/24555810/99828886-d1fd7880-2b5b-11eb-8206-b8b2ad9b1306.png)

* _IPv6 lookup_

![ipv6lookup](https://user-images.githubusercontent.com/24555810/99829009-0113ea00-2b5c-11eb-9f7c-b225c76db124.png)

* _Autonomous system number lookup with BGP stats, peering and prefix informations_

![asnlookup](https://user-images.githubusercontent.com/24555810/98995579-d3162080-2531-11eb-886a-c929ad9dc24c.png)

* _Hostname lookup_

![hostnamelookup](https://user-images.githubusercontent.com/24555810/117335483-7de11900-ae9b-11eb-8016-d1736f182c57.png)

### AS Path tracing ###

* _ASPath trace to www.github.com_

![pathtrace](https://user-images.githubusercontent.com/24555810/117336096-1d9ea700-ae9c-11eb-82dc-6aaf9dc68a6e.png)


* *ASPath trace traversing both an unannounced PNI prefix (FASTWEB->SWISSCOM at hop 11) and an IXP (SWISSCOM -> RCN through Equinix Ashburn at hop 16)*

![pathtrace_pni_ixp](https://user-images.githubusercontent.com/24555810/100301579-b4d00c00-2f98-11eb-82c5-047c190ffcd6.png)


* _Detailed ASPath trace to 8.8.8.8 traversing the Milan Internet Exchange (MIX) IXP peering LAN at hop 5_

![detailed_pathtrace](https://user-images.githubusercontent.com/24555810/117335188-28a50780-ae9b-11eb-98d9-cfd3bc2f1295.png)


### Network search by organization ###

* _Organization search for "github"_

![search_by_org](https://user-images.githubusercontent.com/24555810/99845076-5b20a980-2b74-11eb-9312-986867034cc9.png)

### Suggested ASNs search ###

* _Suggested ASNs for "google"_

![asnsuggest](https://user-images.githubusercontent.com/24555810/98309344-7e6f2480-1fca-11eb-9ec6-df2cb63a62ce.png)

---

## Installation

### Prerequisite packages

This script requires **BASH v4.2** or later. You can check your version by running from your shell: 

`bash -c 'echo $BASH_VERSION'`

Some additional packages are also required for full functionality:

* **Debian 10 / Ubuntu 20.04 (or newer):**

  ```
  apt -y install curl whois bind9-host mtr-tiny jq ipcalc grepcidr ncat aha
  ```
  
* **Debian 9 / Ubuntu 18.04 (or older):**

  ```
  apt -y install curl whois bind9-host mtr-tiny jq ipcalc grepcidr nmap git gcc make && \
  git clone https://github.com/theZiz/aha.git && \
  make install -C aha/
  ```

* **CentOS / RHEL / Rocky Linux 8:**

  ```
  dnf -y install epel-release && \
  dnf -y install curl whois bind-utils mtr jq nmap-ncat ipcalc aha grepcidr
  ```

* **Fedora:**

  ```
  dnf -y install curl whois bind-utils mtr jq nmap-ncat ipcalc aha grepcidr
  ```

* **Manjaro/Arch Linux:**
  ```
   yay -S asn-git
  ``` 
  
* **FreeBSD**:

  `env ASSUME_ALWAYS_YES=YES pkg install bash coreutils curl whois mtr jq ipcalc grepcidr nmap aha`

* **MacOS** (using [Homebrew](https://brew.sh)):

  `brew install bash coreutils curl whois mtr jq ipcalc grepcidr nmap aha && brew link mtr`

  *Notes for MacOS users:*

  * *If `mtr` still can't be found after running the command above, [this](https://docs.brew.sh/FAQ#my-mac-apps-dont-find-usrlocalbin-utilities) may help to fix it.*
  * *Homebrew has a [policy](https://github.com/Homebrew/homebrew-core/issues/35085#issuecomment-447184214) not to install any binary with the **setuid** bit, and mtr (or actually, the mtr-packet helper binary that comes with it) requires to elevate to root to perform traces (good explanations for this can be found [here](https://github.com/traviscross/mtr/issues/204#issuecomment-723961118) and [here](https://github.com/traviscross/mtr/blob/master/SECURITY)). If mtr (and therefore `asn`) traces are not working on your system, you should either run `asn` as root using **sudo**, or set the proper SUID permission bit on the mtr (or better, on the mtr-packet) binary.*
  
* **Windows**:

  * **using [WSL2](https://docs.microsoft.com/en-us/windows/wsl/about) (recommended):**

    Install Windows Subsystem for Linux (v2) by following Microsoft's [guide](https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps). On step 6, choose one of the Linux distributions listed above (Ubuntu 20.04 LTS is recommended).
    Once your WSL2 system is up and running, open a Linux terminal and follow the prerequisite installation instructions above for your distribution of choice.

    *Note for WSL2 users:*

    * *systemd is not currently available in WSL2, so you won't be able to run the **asn server** in daemon mode as described below (if you want server mode you'll have to launch it manually using `asn -l`). An alternative could be to run it as a background process (optionally also using `nohup`), or using Windows' own task scheduler to start it at boot.*

  * **using [Cygwin](https://cygwin.com/index.html):**

    Most of the prerequisite packages listed above for *Debian 10 / Ubuntu 20.04 (or newer)* are obtainable directly with Cygwin's own Setup wizard (or through scripts like *apt-cyg*). You will still have to manually compile (or find a suitable third-party precompiled binary) the *mtr*, *grepcidr* and *aha* tools. Instructions on how to do so can be found directly on the respective projects homepages.

### Script download and installation

Afterwards, to install the **asn** script from your shell to **/usr/bin**:

`curl "https://raw.githubusercontent.com/nitefood/asn/master/asn" > /usr/bin/asn && chmod 0755 /usr/bin/asn`

You can then use the script by running `asn`.

### Installing the *asn server* as a system service

*Note: this step is optional, and these instructions are only for systemd-based Linux systems (most current major distributions).*

To control the **asn server** with utilities like *systemctl* and *service*, and to enable it to automatically start at boot, follow these steps:

1. create a new file called `/etc/systemd/system/asn.service` with the following content (make sure you edit the *ExecStart* line to match your installation path and desired startup options):

   ```
   [Unit]
   Description=ASN lookup and traceroute server
   After=network.target
   StartLimitIntervalSec=0
   
   [Service]
   Type=simple
   Restart=always
   RestartSec=1
   User=nobody
   ExecStart=/usr/bin/asn -l 0.0.0.0
   
   [Install]
   WantedBy=multi-user.target
   ```

2. Enable the *CAP_NET_RAW* capability for the mtr-packet binary:

   `setcap cap_net_raw+ep $(which mtr-packet)`

   *Explanation: this will allow mtr-packet to create raw sockets (and thus perform traces) when launched as an unprivileged user (we're setting up the service to run as user nobody for added security), without the requirement of the setuid-root bit and without having to invoke mtr as root. A thorough explanation for this can be found [here](https://github.com/traviscross/mtr/blob/master/SECURITY).*

3. Now you can refer to standard systemd utilities to perform service operations:

   * To start the service: `systemctl start asn`
   * To stop the service: `systemctl stop asn`
   * To check its status and latest logs: `systemctl status asn`
   * To follow its logging in real time: `journalctl -f -u asn`
   * To start the service automatically on boot: `systemctl enable asn`
   * To disable automatic start on boot: `systemctl disable asn`

### IP reputation API token

The script will perform first-level IPv4/v6 reputation lookups using [StopForumSpam](https://www.stopforumspam.com/), and in case of a match it will perform a second-level, in-depth threat analysis for targets and trace hops using the [IPQualityScore](https://www.ipqualityscore.com/) API. The StopForumSpam API is free and requires no sign-up, and the service aggregates a [huge](https://www.stopforumspam.com/contributors) amount of blacklist feeds.

Still, in order to use the IPQualityScore API for in-depth threat reporting, it's necessary to [sign up](https://www.ipqualityscore.com/create-account) for their service (it's free) and get an API token (it will be emailed to you on sign-up), which will entitle you to 5000 free lookups per month.

Once obtained, the api token should be written to one of the following files (parsed in that order):

`$HOME/.asn/iqs_token` or
`/etc/asn/iqs_token`

The `/etc`-based file should be used when running asn in **server mode**. The `$HOME`-based file takes precedence if both files exist, and is ideal for **user mode** (that is, running `asn` interactively from the command line).

In order to do so, you can use the following command:

***User mode:***

`TOKEN="<your_token_here>"; mkdir "$HOME/.asn/" && echo "$TOKEN" > "$HOME/.asn/iqs_token" && chmod -R 600 "$HOME/.asn/"`

***Server mode:***

`TOKEN="<your_token_here>"; mkdir "/etc/asn/" && echo "$TOKEN" > "/etc/asn/iqs_token" && chmod -R 700 "/etc/asn/" && chown -R nobody /etc/asn/`

Either way, `asn` will pick up your token on the next run (no need to restart the service if running in server mode), and use it to query the IPQualityScore API.

## Usage

##### *Syntax*

`asn [OPTIONS] [TARGET]`

`asn [-v] -l [SERVER OPTIONS]`



where `TARGET` can be one of the following:

* **AS number** -- lookup matching ASN and BGP announcements/neighbours data. Supports "as123" and "123" formats (case insensitive)
* **IPv4/IPv6/Prefix** -- lookup matching route(4/6), IP reputation and ASN data
* **Hostname** -- resolve the host and lookup data (same as IPv4/IPv6 lookup. Supports multiple IPs - e.g. DNS RR)
* **URL** -- extract hostname/IP from the URL and lookup relative data. Supports any protocol prefix, non-standard ports and [prepended credentials](https://en.wikipedia.org/wiki/Basic_access_authentication#URL_encoding)
* **Organization name** -- search by company name and lookup network ranges exported by (or related to) the company



<u>Options</u>:

* `[-d]`
  * enables *detailed mode* (more info below)
* `[-n]`
  * disables path tracing and only outputs lookup info
* `[-o]`
  * forces a Search-By-Organization lookup and skip all target identification checks
* `[-s]`
  * enable *ASN suggestion mode*. This will search for all ASNs matching a given name.
* `[-h]`
  *  Show usage information.
* `[-l]`
  * Launch the script in *server mode*. See **Server Options** below



<u>Server Options</u>:

* `BIND_ADDRESS`
  * IP address (v4/v6) to bind the listening server to (e.g. `asn -l 0.0.0.0`)
* `BIND_PORT` 
  * TCP Port to bind the listening server to (e.g. `asn -l 12345`)
* `BIND_ADDRESS BIND_PORT`
  * IP address and port to bind the listening server to (e.g. `asn -l ::1 12345`)
* `-v`
  * Enable verbose output and debug messages in server mode
* `--allow host[,host,...]`
  * Allow only given hosts to connect to the server
* `--allowfile file`
  * A file of hosts allowed to connect to the server
* `--deny host[,host,...]`
  * Deny given hosts from connecting to the server
* `--denyfile file`
  * A file of hosts denied from connecting to the server
* `-m, --max-conns <n>`
  * The maximum number of simultaneous connections accepted by the server. 100 is the default.

*Note: Every option in server mode (after* `-l`*) is passed directly to the ncat listener.* *Refer to* `man ncat` *for more details on the available commands.*
*Unless specified, the default IP:PORT values of **127.0.0.1:49200** will be used (e.g.* `asn -l`*)*



Default behavior:

* The script will attempt to automatically identify the `TARGET` type, if invoked with `-d` , `-n` or without options, 
* AS path tracing is **enabled by default** for all lookups involving an IP or hostname. In case of multiple IP results, the script will trace the first IP, with a preference for IPv6 if possible on the user's host.

##### *Detailed mode (`-d`)*

- Detailed hop info reporting and RPKI validation can be turned on by passing the `[-d|--detailed]` command line switch. This will enable querying the public [pWhois server](https://pwhois.org/server.who) and the [RIPEStat RPKI validation API](https://stat.ripe.net/docs/data_api#rpki-validation) for every hop in the mtr trace. Relevant info will be displayed as a "tree" below the hop data, in addition to Team Cymru's server output (which only reports the AS name that the organization originating the prefix gave to its autonomous system number). This can be useful to figure out more details regarding the organization's name, the prefix' intended designation, and even (to a certain extent) its geographical scope.

  Furthermore, this will enable a warning whenever RPKI validation fails for one of the hops in the trace, indicating which AS in the path is wrongly announcing (as per current pWhois data) the hop prefix, indicating a potential route leak or BGP hijacking incident.

##### *Organization search (`-o`)*

- The script will try to figure out if the input is an Organization name (i.e. if it doesn't look like an IP address, an AS number or a hostname).
  In order to force an organization search (for example for Orgs containing `.` in their name), pass the `[-o|--organization]` command line switch.

##### *ASN suggest (`-s`)*

- The script will try to find ASNs matching the given search string, using the RIPEStat API. This mode can be used to map all the autonomous systems related to a given company.

##### *Server mode (`-l`)*

- The script will start up a webserver allowing the user to run remote lookups and traceroutes directly from the browser.
  The web server is actually an [ncat](https://nmap.org/ncat/) listener waiting for requests, responding to browsers querying through the HTTP protocol. This interface makes for a straightforward integration into user workflow and no need to download any client-side tools.
  By simply using a Javascript [bookmarklet](https://en.wikipedia.org/wiki/Bookmarklet) or custom [search engine](https://www.howtogeek.com/114176/how-to-easily-create-search-plugins-add-any-search-engine-to-your-browser/), it will be possible to launch remote traces and lookups without ever leaving the browser.
  Refer to the [this section](#running-lookups-from-the-browser) for more information.

##### 

## Notes

##### *Organization data, IP Reputation and noise classification*

- Organization data is taken from pWhois
- IP reputation data is taken from StopForumSpam and IpQualityScore
  - Reputation is also enriched with IP *noise* classification (addresses that have been observed scanning the Internet, and very likely to appear in your logs), taken from [GreyNoise](https://greynoise.io). This will also help identify known-good IPs (e.g. Google networks, CDNs, etc.) from aggressive, known-malicious scanners.

##### *Geolocation*

The script will perform IP and trace hop geolocation with this logic:

1. Using the [RIPE IPmap](https://ipmap.ripe.net/) service as a primary source of geolocation data. It offers extremely precise latency-based geolocation data and is extremely reliable
2. Using the [ip-api](https://ip-api.com/) service as a fallback source of geolocation data
3. Using the [Prefix Whois](https://pwhois.org/) service as a last-resort source of geolocation data

##### *IP Classification*

The script will use the ip-api, RIPE IPmap and PeeringDB services to classify target IPs and trace hops into these categories:

- [Anycast](https://en.wikipedia.org/wiki/Anycast) IP
- Mobile network
- Proxy host (TOR exit node/VPN/etc)
- Hosting network (datacenter/hosting provider/etc)
- IXP network

##### *IXP detection and unannounced prefixes*

- The script will detect [IXPs](https://en.wikipedia.org/wiki/Internet_exchange_point) traversed during path traces by matching them with [PeeringDB](https://www.peeringdb.com/)'s comprehensive dataset of IXP prefixes.
- The script will also attempt a best-effort, fallback generic `whois` lookup when Team Cymru, pWhois and PeeringDB have no info about the IP address or prefix. This is usually the case with some [PNI](https://en.wikipedia.org/wiki/Peering#Private_peering) prefixes, and will give better insight into the path taken by packets.



## Running lookups from the browser

##### *Prerequisite tools for server mode*

Server mode requires two tools for its functionality: `ncat` and `aha`. Specifically, [aha](https://github.com/theZiz/aha) (the ANSI->HTML converter) v0.5+ is required. The ncat tool is contained inside the *nmap* package on older distributions (e.g. Ubuntu 18.04, Debian 9), while it is packaged as a standalone tool on newer ones.

Please refer to the [installation](#installation) section and run the appropriate commands to install the required packages for your operating system, and optionally to install the asn server as a systemd service.

##### *Advantages of server mode*

The main advantage of running lookups from the browser, is that every IP address and AS number gets converted into a hyperlink, allowing to perform subsequent lookups by simply clicking on them.

When looking up an URL/hostname/domain, quick WHOIS info and links to relevant external resources will be available in the results.

When looking up an AS number, all peering ASNs will be clickable. Also, if an AS peers at a public facility, PeeringDB info for that facility will be linked directly. Furthermore, additional external BGP information sources will be linked, directly for the target ASN.

Here are some examples:

![srvmode_hostname_lookup](https://user-images.githubusercontent.com/24555810/117340152-e1217a00-aea0-11eb-9d8f-abaea0d3389e.png)



![srvmode_whois](https://user-images.githubusercontent.com/24555810/117340278-01e9cf80-aea1-11eb-8cad-457f60e80a86.png)



![srvmode_asn_lookup](https://user-images.githubusercontent.com/24555810/117340969-d7e4dd00-aea1-11eb-8e94-88d166f67360.png)



#### Server side

Once started in **server mode**, `asn` will spin up a custom webserver waiting for browser requests. This is what the server-side console looks like:

![server_console](https://user-images.githubusercontent.com/24555810/102154363-80ee5500-3e79-11eb-840f-53e3619be2e4.png)

The server is now ready to accept browser requests (only from the local machine, in this case - since I've launched it with no command line switches, which defaults to listening on **127.0.0.1:49200**. Refer to the [usage](#usage) section for more information about the available server options).

#### Client side

Visit [this page](http://127.0.0.1:49200/asn_bookmarklet) in your browser and follow the instructions to copy the bookmarklet to your bookmarks toolbar:

![bookmarklet_install](https://user-images.githubusercontent.com/24555810/102159720-640b4f00-3e84-11eb-8360-afa79b6f0f5f.png)

##### *How it works*

The bookmarklet is actually a small piece of Javascript code which will grab the hostname of the website you're currently visiting in the browser, and pass it to the server through a simple *HTTP GET* request. The server then proceeds to perform the lookup and traceroute (from its own viewpoint, just like it does when ran interactively from the command line), and feed the results to your browser through an HTML page, mimicking the effect of a scrolling terminal.

The link you drag to the bookmarks bar is actually a *minified* (i.e.: compacted) version of the source javascript code, but for reference, here's the full source:

```javascript
javascript:(function () {
    var asnserver = "localhost:49200";
    var target = window.location.hostname;
    var width = screen.width - screen.width / 7;
    var height= screen.height - screen.height / 4;
    var left = window.innerWidth / 2 - width / 2;
    var top = window.innerHeight / 2 - height / 2;
    window.open("http://" + asnserver + "/asn_lookup&" + target, "newWindow", "width=" + width + ",height=" + height + ",top=" + top + ",left=" + left);
})();
```

If you want to "un-minify" the actual bookmarklet code, you can refer to [this site](https://unminify.com/).

Once the trace is finished, an option to share the output on [termbin](https://termbin.com/) is given to the user. This makes for quick sharing of the traceroute or lookup output with other people:

![termbin](https://user-images.githubusercontent.com/24555810/102160506-dc264480-3e85-11eb-9e14-8c851f261172.png)

![termbin_2](https://user-images.githubusercontent.com/24555810/102168101-f49b5c80-3e8f-11eb-8bc6-9f0592fa9624.png)



#### Search engine setup

In order to take full advantage of having `asn` inside the browser, it is possible to configure it as a custom search engine for the browser search bar. This allows to leverage the server to  search for **ASNs**, **URLs**, **IPs**, **Hostnames**, and so on, depending on the search string.

Generally speaking, this implies instructing the browser that when a certain **keyword** is prepended to a search, the following characters (the actual **search string**, identified by `%s`) have to be passed to a certain URL. The URL is then composed according to this logic, and opened just like a normal webpage.

I've used `@asn` for my keyword, but anything would do. In order to speed up things, one could very well use a shorter tag (e.g. `#`) that, when used in the address bar, automatically switches your search engine to the ASN Lookup server.
Note that the leading `@` sign is not mandatory, just handy since it doesn't get in the way of normal searches, but there's much freedom with that.

For quick reference, the location URL string to enter (for both Firefox and Chrome) is: `http://127.0.0.1:49200/asn_lookup&%s`. Of course that sends lookup requests to the *locally* running ASN server.

Here's how to add a search engine in Firefox and Chrome:

***Firefox***:

* Simply create a new bookmark and fill its details like this:

  ![searchsetup_firefox](https://user-images.githubusercontent.com/24555810/102160982-c6fde580-3e86-11eb-9885-c23eb60d622b.png)

  Afterwards, you will be able to run queries and traceroutes by simply entering, for example, `@asn 8.8.8.8` in the browser's location bar.

***Chrome:***

1. Right click the location bar and select ***Manage search engines...***

   ![searchsetup_chrome_1](https://user-images.githubusercontent.com/24555810/102161929-87d09400-3e88-11eb-9e42-70087e3fab87.png)
   
   2.Click **Add**:

   ![searchsetup_chrome_2](https://user-images.githubusercontent.com/24555810/102162100-dc740f00-3e88-11eb-8037-528fbcc636e9.png)
   
   

   3.Fill in the details as shown below:
   
   ![searchsetup_chrome_3](https://user-images.githubusercontent.com/24555810/102162218-16451580-3e89-11eb-85d1-a4d24c980d7d.png)

As usual, the keyword is entierly customizable to your preference.



***Other browsers:***

* You may want to follow [this post](https://www.howtogeek.com/114176/how-to-easily-create-search-plugins-add-any-search-engine-to-your-browser/) to search for instructions on how to add a custom search engine for your browser of choice.



#### Running the server on an external host

##### *Port forwarding*

In order to access the server remotely, beside binding to `0.0.0.0` (or any other relevant IP address for your scenario),  if the host is behind a NAT router, you'll need to forward the listening port (`BIND_PORT`) from the host/router outside IP to the actual machine where the ASN server is running on.
It is a single TCP port (by default `TCP/49200`), and you can change it via the command line parameters (see [Usage](#usage)).

##### *Textual browser client*

It is possible to launch remote traces from another command line, and view the results directly in the terminal. All it takes is a compatible text browser, for example `elinks` (but you can download results for later reviewing even using `curl` or really anything else).

The script makes use of 8-bit ANSI colors for its output, so the command to launch a remote trace using elinks would be something like this: 

`elinks -dump -dump-color-mode 3 http://<ASN_SRV_IP>:49200/asn_lookup&8.8.8.8`

##### *Security considerations*

The server logic in itself is very simple: the script implements a basic web server entirely in BASH, leveraging the fact that it can talk to a browser using the HTTP protocol and the HTML language, in a reasonably simple way.

The core behind it revolves around [ncat](https://nmap.org/ncat/), a very robust and stable netcat-like network tool. This is the actual "server" listening for incoming connection, and spawning connection handlers (that is, 'single-purpose' instances of the `asn` script itself) as clients connect.

If you decide to open it to the outside (i.e.: binding it to something that is not localhost, and launching traces from outside your local machine), please bear in mind that there is no authentication mechanism (yet) integrated into the code, so theoretically anybody with the right URL could *spawn traceroutes from your server* and view the results (bear in mind however that the server sanitizes user input by stripping any dangerous characters).

To contrast that, fortunately `ncat` implements a robust allow/deny logic (based both on command line parameters and files, a la `/etc/hosts.allow` and `hosts.deny`). The script supports passing parameters directly to `ncat`, therefore it's possible to make full use of its filtering capabilities and lock the server to a restricted range of trusted IPs.

The available options, and some usage examples, can be viewed by running `asn -h`.

*Note: if you plan to run the server somewhere else than your local machine, remember to change the bookmarklet code and the custom search engine URL values to reflect the actual IP of the asn server. It is naturally possible to have multiple bookmarklets and search engine keywords to map to different ASN server instances.*

*For the bookmarklet, you'll need to change this value at the very beginning:* `var asnserver="localhost:49200"` *and make it point to the new address:port pair. No further change is required in the remaining JS code.*



## Thanks

An initial version of this script was featured in the **Security Trails** blog post "[_ASN Lookup Tools, Strategies and Techniques_](https://securitytrails.com/blog/asn-lookup#autonomous-system-lookup-script)". Thank you [Esteban](https://www.estebanborges.com/)!

Thanks [Massimo Candela](https://github.com/massimocandela/) for your support and excellent work on [IPmap](https://ipmap.ripe.net/), [BGPlay](https://github.com/massimocandela/BGPlay) and [TraceMON](https://github.com/RIPE-NCC/tracemon)!

## Feedback and contributing

Any feedback or pull request to improve the code is welcome. Feel free to contribute!
