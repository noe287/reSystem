#! /usr/bin/python
## (C) Copyright 2008 AirTies Wireless Networks
## Courtesy of Peter Nixon
import os, sys
import binascii

print "// AirTies Firmware key generator"

try:
        key = sys.argv[1]
        if len(key) != 32:
                print "ERROR: Key needs to be 32 hex characters long, So I will generate my own"
                sys.exit()
except:
        key = binascii.hexlify(os.urandom(16))

print "// Key: " + key + "\n"

print "#ifndef __SIGNATURE_KEY_H"
print "#define __SIGNATURE_KEY_H"
print ""
print "char acKey[16][3] ="
print "{"
for i in range(0, len(key), 2):
        mystring = "\t\t{'%s', '%s', '\\0'}," % (key[i], key[i+1])
        print mystring
else:
        print "};"

print ""
print "#endif /* __SIGNATURE_KEY_H */"
print ""
