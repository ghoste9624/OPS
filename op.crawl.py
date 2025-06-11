#!/usr/bin/env python3

import argparse
import requests
import logging
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse

class WebCrawler:
    def __init__(self, start_url, max_depth, output_file, verbose):
        self.start_url = start_url
        self.max_depth = max_depth
        self.output_file = output_file
        self.verbose = verbose
        self.visited_urls = set()
        self.logger = self._setup_logger()

    def _setup_logger(self):
        logger = logging.getLogger('web_crawler')
        logger.setLevel(logging.DEBUG if self.verbose else logging.INFO)
        formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
        ch = logging.StreamHandler()
        ch.setFormatter(formatter)
        logger.addHandler(ch)
        return logger

    def _get_page(self, url):
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()  # Raise HTTPError for bad responses (4xx or 5xx)
            return response.text
        except requests.exceptions.RequestException as e:
            self.logger.error(f"Error fetching {url}: {e}")
            return None

    def _extract_links(self, html_content, base_url):
        soup = BeautifulSoup(html_content, 'html.parser')
        links = []
        for link_tag in soup.find_all('a', href=True):
            absolute_url = urljoin(base_url, link_tag['href']) # Handles relative URLs
            if self._is_valid_url(absolute_url):
               links.append(absolute_url)

        return links

    def _is_valid_url(self, url):
         parsed_url = urlparse(url)
         return all([parsed_url.scheme, parsed_url.netloc]) and parsed_url.scheme in ('http', 'https')

    def _crawl(self, url, depth=0):
        if depth > self.max_depth or url in self.visited_urls:
            return

        self.visited_urls.add(url)

        self.logger.info(f"Crawling {url}, Depth: {depth}") # Show url and depth if verbose mode

        html_content = self._get_page(url)
        if html_content:
            # Example: Extract data (customize to your needs)
            soup = BeautifulSoup(html_content, 'html.parser')
            title = soup.title.string if soup.title else "No Title Found"
            self.logger.debug(f"Title: {title}")

            if self.output_file:
                 with open(self.output_file, 'a', encoding='utf-8') as f:
                      f.write(f"URL: {url}\nTitle: {title}\n\n")

            links = self._extract_links(html_content, url)
            for link in links:
                self._crawl(link, depth+1)

    def run(self):
         self._crawl(self.start_url)
         self.logger.info("Crawling Complete.")

def main():
    parser = argparse.ArgumentParser(description="Advanced Web Crawler")

    # Positional argument
    parser.add_argument("URL", help="The URL to start crawling from")

    # Optional arguments
    parser.add_argument("-d", "--max_depth", type=int, default=3, help="Maximum crawl depth (default: 3)")
    parser.add_argument("-o", "--output_file", help="Output file to save results")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose logging")

    args = parser.parse_args()

    crawler = WebCrawler(args.URL, args.max_depth, args.output_file, args.verbose)
    crawler.run()

if __name__ == "__main__":
    main()
