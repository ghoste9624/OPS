#!/bin/bash

# Function to check links
link_checker() {                                                                                                                                          
    echo ""
    echo "Checking Link For Errors: $url"
    echo ""
    linkchecker "$url"
}

# Function to check URL status code
check_url_status() {
    local url="$1"
    echo ""
    echo "Checking status of: $url"
    echo ""
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url") # Use curl to fetch the status code
    wget $url
    echo "Status code: $response"
}

# Function to get WHOIS information for a domain
get_whois_info() {
    local domain="$1"
    echo ""
    echo "Getting WHOIS Information For: $domain"
    echo ""
    whois "$domain"
}

# Function to dig name servers for a domain
dig_domain_servers() {
    local domain="$1"                                                                                                                                      
    echo ""
    echo "Getting Name Servers For: $domain"
    echo ""
    dig "$domain" NS
    nslookup "$domain"
    host -a -A "$domain"
}

# Function to perform recursive dns lookup on a domain
recursive_dns_lookup() {
    local domain="$1"                                                                                                                                      
    echo ""
    echo "Getting DNS Information For: $domain"
    echo ""
    dig "$domain" +trace
}

# Function to reverse dns lookuo for an IP address 
reverse_dns_lookup() {
    local domain="$1"                                                                                                                                      
    echo ""
    echo "Getting DNS information From: $domain"
    echo ""
    dig -x "$domain" 
}

# Function to search for subdomains 
sub_scan() {
    local domain="$1"
    echo ""
    echo "Searching For Subdomains: $domain"
    echo ""
    ./subscan "$domain" 
}

# Function to sslscan vulnerabilities on a domain 
sslscan_domain() {
    local domain="$1"                                                                                                                                      
    echo ""
    echo "Searching Vulnerabilities For: $domain"
    echo ""
    sslscan "$domain" 
}

# Function to retrieve encrypted SSL/TLS certificates from a domain 
ssl_certs_domain() {
    local domain="$1"                                                                                                                                      
    echo ""
    echo "Getting Certificates For: $domain"
    echo ""
    ./ssl.sh -d "$domain" 
}

# Function to scan for Vulnerabilities with payload injection 
xss_scan() {
    local url="$1"
    echo ""
    echo "Scanning For Vulnerabilities: $url"
    echo ""
    python3 xss.py -u "$url" -p xss-payload-list.txt -v
}

# Function to webtech scan an url 
webtech_urls() {
    local url="$1"                                                                                                                                      
    echo ""
    echo "Getting Information For: $url"
    echo ""
    webtech -u "$url" --rua
}

# Function to get robots txt and http headers
robots_txt() {
    local url="$1"                                                                                                                                      
    echo ""
    echo "Fetching Cookies And Header Info From: $url"
    echo ""
    curl -i "$url"/page     
    curl -ILk "$url"
    curl -Lk "$url"/robots.txt
}

# Function to set header cookies
set_cookie() {
    echo ""
    echo "Getting Cookies From: $url"
    echo ""
    python3 cookie.py "$url" --headers --cookies
}

# Function to trace a domains script http headers
script_trace() {
    local domain="$1"                                                                                                                                      
    echo ""
    echo "Scanning NMAP For: $domain"
    echo ""
    nmap -sV -A "$domain" --script-trace --script=http-headers --unprivileged -o "$domain".scrpt.trace
}

# Function to traceroute a domain or IP address 
traceroute_scan() {
    local domain="$1"                                                                                                                                      
    echo ""
    echo "Scanning Traceroute For: $domain"
    echo ""
    traceroute "$domain" 
}

# Function to scan ports of a domain
scan_ports() {
    local domain="$1"
    echo ""
    echo "Scanning Common Ports For: $domain"
    echo ""
    nmap -sT -p 80,443,22,21 "$domain" --unprivileged # Scan common web, SSH, and FTP ports
}

# Function to Google search query 
google_search() {                                                                                                                                         
    echo ""
    echo "Searching Google For: $query"
    echo ""
    google "$query"
}

# Function to crawl websites
web_crawler() {
    echo ""
    echo "Starting Crawler"
    echo ""
    python3 op.crawl.py "$url" -o crawler.txt -v 
}

# Function to Search a Username 
user_search() {                                                                                                                                          
    echo ""
    echo "Searching Websites For: $username"
    echo ""
    search4 -u "$username"
    linkook "$username" --concise --show-summary --check-breach --scan-all --print-all 
    thorndyke "$username"
}

# Function to Search an email address 
email_search() {                                                                                                                                          
    echo ""
    echo "Searching Websites For: $email"
    echo ""
    holehe "$email"
}

# Function to parse a phone number
phone_parser() {
    echo ""
    echo "Getting Phone Number Information"
    echo ""
    python3 p2.py 
}

# Function to open browser search
open_browser() {
    echo ""
    echo "Opening Web Browser"
    echo ""
    lynx "$url" 
}

# Function to give date, time and your IP information 
my_ip() {
    echo""
    echo "Checking Your Information"
    echo ""
    echo ""
    date
    echo ""
    echo ""
    curl ipinfo.io; curl -L tacs-sys.com | grep -i illusion
    echo ""
    echo ""
}

# Function to get the system storage 
system_storage() {
    echo ""
    echo ""
    df
    echo ""
    echo ""
    df -h
    echo ""
    echo ""
    date
    echo ""
    echo ""
}

# Function to perform a system speed test
speed_test() {
    echo ""
    echo "Scanning Your System"
    echo ""
    speedtest-cli
}

# Main menu loop
while true; do
    #clear # Clear the screen
    echo ""
    echo -e "\033[97m"
    echo ""
    echo "====================================="
    echo "             OSINT - OPS "
    echo "====================================="
    echo ""
    echo " [01]  Linkchecker Information"
    echo " [02]  Check URL Status"
    echo " [03]  Get WHOIS Information"
    echo " [04]  Domain Name Servers"
    echo " [05]  Recursive DNS lookup"
    echo " [06]  Reverse DNS Lookup"
    echo " [07]  Subdomain Enumeration"
    echo " [08]  SSL/TLS Scanner"
    echo " [09]  SSL/TLS Encrypted Certificates"
    echo " [10)  XSS Payload Injection"
    echo " [11]  Webtech Scan Information"
    echo " [12]  Robots.txt - HTTP Headers"
    echo " [13]  Set Cookies - Headers"
    echo " [14]  NMAP Script Trace"
    echo " [15]  Traceroute Domain Or IP"
    echo " [16]  Scan Common Ports Of A Domain"    
    echo " [17]  Google Search Query - Dorker"
    echo " [18]  Start Web Crawler"
    echo " [19]  Username Search"
    echo " [20]  Check A Phone Number"
    echo " [21]  Email Search"
    echo " [22]  Open Browser"
    echo " [23]  Your IP Information"
    echo " [24]  Check Your System Storage"
    echo " [25]  System Speed Test"
    echo ""
    echo " [00]  Exit"
    echo ""
    echo "====================================="
    echo ""
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo ""
            echo "  [*]  Get Link Information"
            echo ""
            read -p "[URL]: " url
            link_checker "$url"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
        2)
            echo ""
            echo "  [*]  Check Status "
            echo ""
            read -p "[URL]: " url
            check_url_status "$url"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
        3)
            echo ""
            echo "  [*]  WHOIS Lookup "
            echo ""
            read -p "[Domain] [IP]: " domain
            get_whois_info "$domain"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
        4)
            echo ""
            echo "  [*]  Check Name Servers "
            echo ""
            read -p "[Domain]: " domain
            dig_domain_servers "$domain"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
        5)
            echo ""
            echo "  [*]  Recursive DNS Lookup "
            echo ""
            read -p "[Domain]: " domain
            recursive_dns_lookup "$domain"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
        6)
            echo ""
            echo "  [*]  Reverse DNS Lookup "
            echo ""
            read -p "[IP]: " IP
            reverse_dns_lookup "$IP"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
        7)
            echo ""
            echo "  [*]  Subdomain Enumeration"
            echo ""
            read -p "[Domain]: " domain
            sub_scan "$domain"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
        8)
            echo ""
            echo "  [*]  Scan For Vulnerabilities"
            echo ""
            read -p "[Domain]: " domain
            sslscan_domain "$domain"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
        9)
            echo ""
            echo "  [*]  SSL/TLS Encrypted Certificates"
            echo ""
            read -p "[Domain]: " domain
            ssl_certs_domain "$domain"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       10)
            echo ""
            echo "  [*]  XSS Payload Injection"
            echo ""
            read -p "[URL]: " url
            xss_scan "$url"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       11)
            echo ""
            echo "  [*]  Webtech Scan - Random User Agent Set "
            echo ""
            read -p "[URL]: " url
            webtech_urls "$url"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       12)
            echo ""
            echo "  [*]  Robots.txt - HTTP Headers "
            echo ""
            read -p "[Domain] [URL]: " url
            robots_txt "$url"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;     
       13)
            echo ""
            echo "  [*]  Set Cookies - Headers "
            echo ""
            read -p "[Domain] [URL]: " domain
            set_cookie "$domain"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       14)
            echo ""
            echo "  [*]  NMAP Script Trace  "
            echo ""
            read -p "[Domain]: " domain
            script_trace "$domain"
            echo ""
            echo "   File Saved > "$domain".script.trace"
            echo "" 
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       15)
            echo ""
            echo "  [*]  Traceroute Domain or IP "
            echo ""
            read -p "[Domain] [IP]: " domain
            traceroute_scan "$domain"           
            echo "" 
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       16) 
            echo ""
            echo "  [*]  Scanning Common Ports"
            echo ""
            read -p "[Domain]: " domain 
            scan_ports "$domain"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       17)
            echo ""
            echo "  [*]  Enter The Search Query"
            echo ""
            read -p "[Query]: " query 
            google_search "$query"       
            echo ""
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       18)
            echo ""                                              
            echo "  [*]  Start Crawling A Website"
            echo ""                                              
            read -p "[URL]: " url
            web_crawler "$url"                                
            echo ""
            echo "   File Saved > crawler.txt"       
            echo ""                                              
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       19)
            echo ""
            echo "  [*]  Username Search"
            echo ""
            read -p "[Username]: " username
            user_search "$username"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       20)
            phone_parser 
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       21)
            echo ""
            echo "  [*]  Search Websites For Enail"
            echo ""
            read -p "[Email Address]: " email
            email_search "$email"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       22)
            echo ""
            echo "  [*]  Open Browser e.g., google.com"
            echo ""
            read -p "[Domain] [URL]: " url
            open_browser "$url"
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       23)
            my_ip
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       24)
            system_storage
            echo ""
            read -p "  Press Enter to continue..."
            ;;
       25)
            speed_test 
            echo ""
            read -p "  Press Enter to continue..."
            echo ""
            ;;
       00)
            echo ""
            echo "  Exiting..."
            echo ""
            exit 0
            ;;
        *)
            echo "  Invalid choice. Please try again."
            echo ""
            read -p "  Press Enter to continue..."
            ;;
    esac
done
