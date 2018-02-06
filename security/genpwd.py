#!/usr/bin/env python3
"""
This script will generate a sha-512 password for /etc/shadow.
"""
import crypt
import hmac
import random
import string

PWD = ''.join(random.SystemRandom().choice(string.ascii_letters + string.digits) for _ in range(24))
print('Password: ' + PWD)

SLT = crypt.mksalt(crypt.METHOD_SHA512)
print('Salt: ' + SLT)

HSH = crypt.crypt(PWD, SLT)
print('Hash: {CRYPT}' + HSH)

CMPD = hmac.compare_digest(HSH, crypt.crypt(PWD, HSH))
print('Hash Verified: ' + str(CMPD))
