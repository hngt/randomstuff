#!/usr/bin/env python3
# a tool to get translations of words from persus (http://www.perseus.tufts.edu)
import bs4
import re
import urllib.request
import sys

lang_list = {
	"-ar" : "ar",
	"-greek" : "greek",
	"-la" : "la",
	"-non" : "non",
	}
	
lang = "greek"
usage = "Usage: perseus [-ar,-greek,-la,-non] [query]"

def text_getter(lst):
	return [re.sub(r'\n\s*\n', r'\n\n', word.get_text().strip(), flags=re.M) for word in lst]

try:
	query = sys.argv[1]
except IndexError:
	print(usage)
	exit()

if query[0] == "-":
	try:
		lang = lang_list[query]
		query = sys.argv[2]
	except Exception:
		print(usage)
		exit()

url = "http://www.perseus.tufts.edu/hopper/morph?la={}&l={}".format(lang,query)
data = urllib.request.urlopen(url)
site_soup = bs4.BeautifulSoup(data.read(), "html.parser")
analyses=site_soup.select("div.analysis")

if not analyses:
		print("Word not found, or other minor error.")
		exit()

for analysis in analyses:
	word = text_getter(analysis.select("h4.{}".format(lang)))[0]
	translation = text_getter(analysis.select("span.lemma_definition"))[0]
	attributes = text_getter(analysis.select("td"))[1::3]
	complex_words = text_getter(analysis.select("td.{}".format(lang)))
	print(word,"\t",translation)
	for attribute, cword in zip(attributes, complex_words):
		print(cword,"\t", attribute)
	if analyses[-1] != analysis:
		print("- - -")