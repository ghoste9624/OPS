import requests
import argparse

def extract_data(url, display_headers, display_cookies):
    """Extracts headers and cookies from the given URL and displays based on flags."""
    try:
        response = requests.get(url)

        if display_headers or (not display_headers and not display_cookies): # Display headers by default if neither flag is set
            print("Response Headers:")
            for header, value in response.headers.items():
                print(f"{header}: {value}")

        if display_cookies:
            print("\nResponse Cookies:")
            cookies = response.cookies
            for cookie in cookies:
                print(f"{cookie.name}: {cookie.value}")

    except requests.exceptions.RequestException as e:
        print(f"Error making request: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Extract headers and cookies from a target URL <<< https://github.com/ghoste9624/eXtract >>>')
    parser.add_argument('URL', type=str, help='The URL to extract data from (headers will be extracted by default). Combine optional flags to display both extracted headers and cookies.')
    parser.add_argument('--headers', action='store_true', help='Display extracted headers data only from a target (combine optional flags).')
    parser.add_argument('--cookies', action='store_true', help='Display extracted cookies data only from a target (combine optional flags).')
    args = parser.parse_args()

    extract_data(args.URL, args.headers, args.cookies)
