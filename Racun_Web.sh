#!/bin/bash

export PATH="$PATH:/home/user/.local/bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TARGET="$1"
MI_IP=$(ip route get 1.1.1.1 | grep -oP 'src \K\S+')

BASE_DIR="recon_$(date +%Y%m%d)"
mkdir -p "$BASE_DIR"

mostrar_menu() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}    HERRAMIENTAS DE RECONOCIMIENTO WEB v1.0${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "Target: ${YELLOW}$TARGET${NC}              Yo: ${YELLOW}$MI_IP${NC}"
    echo -e "Directory results: ${YELLOW}$BASE_DIR${NC}"
    echo -e "${BLUE}───────────────────────────────────────────────────────${NC}"
    echo -e " 1) ${GREEN}Nmap${NC}"
    echo -e " 2) ${GREEN}Gobuster${NC}"
    echo -e " 3) ${GREEN}WhatWeb${NC}"
    echo -e " 4) ${GREEN}Nikto${NC}"
    echo -e " 5) ${GREEN}SQLMap${NC}"
    echo -e " 0) ${RED}EXIT${NC}"
    echo -e "${BLUE}───────────────────────────────────────────────────────${NC}"
}

run_nmap() {
	echo -e "${BLUE}════════════════NMAP═════════════════${NC}"
	echo -e "What kind of scan will you use?"
	echo -e "${GREEN}1) Paranoic mode${NC}"
	echo -e "${GREEN}2) Agresive mode${NC}"
	echo -e "${GREEN}3) Balanced mode${NC}"
	echo -e "${GREEN}4) Faster mode${NC}"

	read -p "Choose a mode: " mode
	case $mode in
		1)
		echo -e "${BLUE}[*] Ejecutando Nmap...${NC}"
		nmap -sS -T0 -f -n -Pn --scan-delay 10s -D RND:5 "$TARGET" -oG "$BASE_DIR/nmap_scan"
		;;
		2)
		echo -e "${BLUE}[*] Ejecutando Nmap...${NC}"
		nmap -sSC -sV -p- --open --min-rate 5000 -vvv -n "$TARGET" -oG "$BASE_DIR/nmap_scan"
		;;
		3)
		echo -e "${BLUE}[*] Ejecutando Nmap...${NC}"
		nmap -sS -T4 -p- --open -n -Pn "$TARGET" -oG "$BASE_DIR/nmap_scan"
		;;
		4)
		echo -e "${BLUE}[*] Ejecutando Nmap...${NC}"
		nmap -sS -T4 -F -n -Pn "$TARGET" -oG "$BASE_DIR/nmap_scan"
		;;
		*) echo -e "${RED}[!] Not valid option${NC}";;
		esac
		
    echo -e "${GREEN}[+] Nmap completed. Results in $BASE_DIR/nmap_scan.txt${NC}"
}

run_gobuster() {
    echo -e "${BLUE}════════════════GoBuster═════════════════${NC}"
    read -p "Port web (default 80): " web_port
    web_port=${web_port:-80}
    wordlist="/usr/share/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt"
    dns="/usr/share/seclists/Discovery/DNS/bitquark-subdomains-top100000.txt"
    vhost="/usr/share/seclists/Discovery/DNS/namelist.txt"
    

	echo -e "What do you want to search for?"
	echo -e "${GREEN}1) Directory and file discovery DIR${NC}"
	echo -e "${GREEN}2) Subdomain enumeration DNS${NC}"
	echo -e "${GREEN}3) Virtual host detection VHOST${NC}"
	
    read -p "Search type: " type

    case $type in
		1)
		gobuster dir -u "http://$TARGET:$web_port" -w "$wordlist" -x php,html,txt,js -o "$BASE_DIR/gobuster_scan.txt"
		;;
		2)
		gobuster dns -d "http://$TARGET:$web_port" -w "$dns" -t 50 -o "$BASE_DIR/gobuster_scan_dns.txt"
		;;
		3)
		gobuster vhost -u "http://$TARGET:$web_port" -w "$vhost" --append-domain -o "$BASE_DIR/gobuster_scan_vhost.txt"
		;;
		*) echo -e "${RED}[!] Not valid option${NC}";;
		esac
	
    echo -e "${GREEN}[+] Gobuster completed. Results in $BASE_DIR/gobuster_scan.txt_XXX${NC}"
}

run_whatweb() {
    echo -e "${BLUE}[*] Runing WhatWeb...${NC}"
    whatweb "http://$TARGET" | tee "$BASE_DIR/whatweb.log"
    echo -e "${GREEN}[+] WhatWeb completed. Results in $BASE_DIR/whatweb.log${NC}"
}

run_nikto() {
    echo -e "${BLUE}[*] Runing Nikto...${NC}"
    nikto -h "http://$TARGET" -output "$BASE_DIR/nikto_scan.txt"
    echo -e "${GREEN}[+] Nikto completed. Results in $BASE_DIR/nikto_scan.txt${NC}"
}

run_sqlmap() {
    echo -e "${BLUE}[*] Running SQLMap...${NC}"
    read -p "  URL completa con parámetro (ej. http://$TARGET/page?id=1): " sql_url
    if [ -n "$sql_url" ]; then
        sqlmap -u "$sql_url" --batch --level=2 --risk=2 --output-dir="$BASE_DIR/sqlmap"
        echo -e "${GREEN}[+] SQLMap completed. Results in $BASE_DIR/sqlmap${NC}"
    else
        echo -e "${RED}[!] URL no provided. skippin SQLMap.${NC}"
    fi
}

# --- Main ---
if [ -z "$TARGET" ]; then
    echo -e "${RED}[!] Error: you didn't enter a target. Quitting.${NC}"
    exit 1
fi

while true; do
    mostrar_menu
    read -p "Select an option (0-5): " opcion
    case $opcion in
        1) run_nmap ;;
        2) run_gobuster ;;
        3) run_whatweb ;;
        4) run_nikto ;;
        5) run_sqlmap ;;
        0) echo -e "${RED}Adios...${NC}"; exit 0 ;;
        *) echo -e "${RED}[!] Not valid option.${NC}"; sleep 1 ;;
    esac
    echo -e "${BLUE}───────────────────────────────────────────────────────${NC}"
    read -p "Press Enter to continue..."
done
