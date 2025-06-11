import argparse
import requests
from bs4 import BeautifulSoup
import urllib.parse
import logging  # For logging functionality

# Configure logging
logging.basicConfig(level=logging.WARNING, format='%(asctime)s - %(levelname)s - %(message)s')

def scan_xss(url, payloads):
    """
    Scans a given URL for XSS vulnerabilities using provided payloads.
    """
    logging.info(f"Scanning URL: {url}")  # Log the scanned URL
    try:
        response = requests.get(url)  # Fetch page content
        soup = BeautifulSoup(response.text, 'html.parser')  # Parse HTML

        # Example: Test forms for XSS
        forms = soup.find_all("form")
        for form in forms:
            form_details = get_form_details(form)
            for payload in payloads:
                logging.debug(f"Testing form with payload: {payload}")  # Log payload for verbose output
                submit_form(form_details, url, payload)

        # Example: Test URL parameters for XSS
        parsed = urllib.parse.urlparse(url)
        params = urllib.parse.parse_qs(parsed.query)
        for param in params:
            for payload in payloads:
                logging.debug(f"Testing URL parameter '{param}' with payload: {payload}")  # Log payload for verbose output
                test_url = url.replace(f"{param}={params[param][0]}", f"{param}={urllib.parse.quote(payload)}")
                response = requests.get(test_url)
                if payload in response.text:
                    logging.warning(f"Potential XSS vulnerability found in URL parameter '{param}' with payload: {payload}")  # Log potential vulnerability

    except Exception as e:
        logging.error(f"Error scanning URL {url}: {str(e)}")  # Log errors

def get_form_details(form):
    """
    Extracts details from an HTML form.
    """
    details = {}
    action = form.attrs.get("action", "").lower()
    method = form.attrs.get("method", "get").lower()
    inputs = []
    for input_tag in form.find_all("input"):
        input_type = input_tag.attrs.get("type", "text")
        input_name = input_tag.attrs.get("name")
        inputs.append({"type": input_type, "name": input_name})
    details["action"] = action
    details["method"] = method
    details["inputs"] = inputs
    return details

def submit_form(form_details, url, value):
    """
    Submits a form with a given value.
    """
    target_url = urllib.parse.urljoin(url, form_details["action"])
    inputs = form_details["inputs"]
    data = {}
    for input in inputs:
        if input["type"] == "text" or input["type"] == "search":
            input_name = input["name"]
            data[input_name] = value
        # Handle other input types as needed (e.g., checkboxes, radio buttons)

    if form_details["method"] == "post":
        return requests.post(target_url, data=data)
    else:
        return requests.get(target_url, params=data)

def main():
    parser = argparse.ArgumentParser(description="Simple XSS Scanner")
    parser.add_argument("-u", "--url", required=True, help="Target URL")
    parser.add_argument("-p", "--payloads", help="Path to a file containing XSS payloads (one per line)")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose logging")

    args = parser.parse_args()

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)  # Set logging level to DEBUG for verbose output

    if args.payloads:
        with open(args.payloads, 'r') as f:
            payloads = [line.strip() for line in f if line.strip()]
    else:
        payloads = [
            "<script>alert('XSS')</script>",
            "\"'><img src=x onerror=alert('XSS')>\""
        ]  # Default payloads

    scan_xss(args.url, payloads)

if __name__ == "__main__":
    main()
