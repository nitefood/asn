#!/usr/bin/env bash

read -r -d '' banner <<- END_OF_BANNER
#########################################################################################################"
# Helper script to prepare the GCP environment (install prerequisite packages / install the ASN script) #
# Project homepage: https://github.com/nitefood/asn                                                     #
#########################################################################################################
END_OF_BANNER

green=$'\e[38;5;035m'
blue=$'\e[38;5;038m'
red=$'\e[38;5;203m'
black=$'\e[38;5;016m'
greenbg=$'\e[48;5;035m'${black}
dim=$'\e[2m'
default=$'\e[0m'

clear
sudo mkdir -p /etc/asn
echo -e "${dim}$banner${default}\n"
echo -en "Enter your IPQualityScore API token (or press Enter to skip): "
read -sr IQS_TOKEN
echo -en "\nEnter your ipinfo.io API token (or press Enter to skip): "
read -sr IPINFO_TOKEN
echo -en "\nEnter your Cloudflare API token (or press Enter to skip): "
read -sr CLOUDFLARE_TOKEN

if [ -n "$IQS_TOKEN" ]; then
	echo -en "\n\n- Enabling IPQualityScore API..."
	echo "$IQS_TOKEN" | sudo tee /etc/asn/iqs_token &>/dev/null
	echo "${green}OK${default}"
else
	echo -e "\n\n- IPQualityScore API ${red}DISABLED${default}"
fi
if [ -n "$IPINFO_TOKEN" ]; then
	echo -en "- Enabling ipinfo.io API..."
	echo "$IPINFO_TOKEN" | sudo tee /etc/asn/ipinfo_token &>/dev/null
	echo "${green}OK${default}"
else
	echo -e "- ipinfo.io API ${red}DISABLED${default}"
fi
if [ -n "$CLOUDFLARE_TOKEN" ]; then
	echo -en "- Enabling Cloudflare API..."
	echo "$CLOUDFLARE_TOKEN" | sudo tee /etc/asn/cloudflare_token &>/dev/null
	echo "${green}OK${default}"
else
	echo -e "- Cloudflare API ${red}DISABLED${default}"
fi

echo -en "- Installing prerequisite packages..."
sudo apt update &>/dev/null
sudo apt -y install curl whois bind9-host mtr-tiny jq ipcalc grepcidr nmap ncat aha &>/dev/null
echo -e "${green}OK${default}"
echo -en "- Installing the asn script..."
sudo install -m 755 asn /usr/bin
echo -e "${green}OK${default}"
echo -e "\n${greenbg} All done ${default}\n"
echo -e "Example usage:\n\tServer mode : ${blue}asn -l${default}\n\tASPath trace: ${blue}asn 1.1.1.1${default}\n\nFor a full feature list visit ${blue}https://github.com/nitefood/asn${default}\n\n"
