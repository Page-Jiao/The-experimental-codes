import requests
import urllib.request
import re
print("dddddd")
url=requests.get('https://www.sirm.org/en/2020/03/31/covid-19-case-5/')
html=url.text
urls = re.findall('https://www.sirm.org/wp-content/uploads/2020/03/.*.jpeg',html)
print(len(urls))
for image in urls:
    print(image)
