#!/bin/bash
#the script uses for 2 purposes
# 1. get package id, package name, and package homepage url for each scan number. The result will show on "package_url.txt"
# 2. get license id, and license name for each scan number. The result will show on "license_url.txt"

echo "Type your login USER of scan, followed by [ENTER]"
read user
echo "Type your login PASSWORD of scan, followed by [ENTER]"
read password
echo "type the LOAS number, followed by[ENTER]"
read loas
curl -X GET --basic -u "$user:$password" -H "Accept: application/vnd.openlogic.olexgovernance+xml" "https://olex-secure.openlogic.com/loas/$loas" |perl -nle 'print $& if m{http(s?)://olex-secure.openlogic.com/packages/[^ \"()\<>]*}' >packagelist.txt

curl -X GET --basic -u "$user:$password" -H "Accept: application/vnd.openlogic.olexgovernance+xml" "https://olex-secure.openlogic.com/loas/$loas" |perl -nle 'print $& if m{http(s?)://olex-secure.openlogic.com/licenses/[^ \"()\<>]*}' >licenselist.txt
#grep "package id" 
while read i; do
  curl -X GET --basic -u "$user:$password" -H "Accept: application/vnd.openlogic.olexgovernance+xml" "${i}"| egrep "<package_id>|<name>|<homepage_url>"| sed 's/<\/\?[^>]\+>//g'| paste -d, -s  >>package-url.txt
done <packagelist.txt
while read i; do
  curl -X GET --basic -u "$user:$password" -H "Accept: application/vnd.openlogic.olexgovernance+xml" "${i}"| egrep "<ol_license_id>|<name>"| sed 's/<\/\?[^>]\+>//g'| paste -d, -s  >>license-url.txt
done <licenselist.txt