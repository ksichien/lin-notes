#!/usr/bin/env python3
"""
This script will retrieve all mail addresses with the ldap module.
Afterwards, it will check them one by one for breaches at https://haveibeenpwned.com/
"""
import json
import time
import cfscrape
import ldap

LDAP_SRV = 'ldaps://ldap.vandelayindustries.com:636'
LDAP_USR = 'uid=scraper,ou=services,dc=internal,dc=vandelayindustries,dc=com'
LDAP_PWD = 'scraper_password'

LDAP_OBJ = ldap.initialize(LDAP_SRV)
LDAP_OBJ.simple_bind_s(LDAP_USR, LDAP_PWD)

LDAP_BASE = 'dc=internal,dc=vandelayindustries,dc=com'
SRCH_FLTR = "mail=*"

URL_BASE = 'https://haveibeenpwned.com/api/v2/breachedaccount/'
URL_TR = '?truncateResponse=true'

SRCH_R = LDAP_OBJ.search_s(LDAP_BASE, LDAP_OBJ.SCOPE_SUBTREE, SRCH_FLTR)
print('Looping over ' + str(len(SRCH_R)) + ' users.')

for r in SRCH_R:
    user = b''.join(r[1]['mail']).decode('utf-8') # Converts bytes returned by ldap into a string.
    full_url = URL_BASE + user + URL_TR
    scraper = cfscrape.create_scraper()
    json_pwned = scraper.get(full_url).content
    if json_pwned:
        parsed_json_pwned = json.loads(json_pwned)
        for j in parsed_json_pwned:
            print('User ' + user + ' was located in the ' + j['Name'] + ' breach.')
    else:
        print('User ' + user + ' was not found.')
time.sleep(2)
