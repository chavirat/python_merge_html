#!/bin/bash
#the script uses for 2 purposes
# 1. get package id, package name, and package homepage url for each scan number. The result will show on "package_url.txt"
# 2. get license id, and license name for each scan number. The result will show on "license_url.txt"
echo "Select 1.To export PACKAGE_URL OR 2.To export LICENSE and PACKAGE URL, followed by [ENTER]"
read choice
echo "Type your login USER of scan, followed by [ENTER]"
read user
echo "Type your login PASSWORD of scan, followed by [ENTER]"
read password
declare -a loass
echo "type the LOAS numbers ex. 40038 40039 40040, followed by[ENTER]"
read loass
package(){
for loas in ${loass[@]};
do
   echo "Run the loas number " $loas "............................."
   #package list
   curl -X GET --basic -u "$user:$password" -H "Accept: application/vnd.openlogic.olexgovernance+xml" "https://olex-secure.openlogic.com/loas/$loas" |perl -nle 'print $& if m{http(s?)://olex-secure.openlogic.com/packages/[^ \"()\<>]*}' >packagelist-$loas.txt 
   #get package id, name, homepage url
   while read i; do
    curl -X GET --basic -u "$user:$password" -H "Accept: application/vnd.openlogic.olexgovernance+xml" "${i}"| 
    perl -nle 'print $& if m{(?<=<package_id>).*(?=</package_id>)} | m{(?<=<name>).*(?=</name>)} | m{(?<=<homepage_url>).*(?=</homepage_url>)}'|  sed 's/^[ \t]*//;s/[ \t]*$//' | sed ':a;N;$!ba;s/\n/|/g' >>package-url-$loas.txt
   done <packagelist-$loas.txt
done
}
license(){
for loas in ${loass[@]};
do
   echo "Run the loas number " $loas "............................."
   #license list
   curl -X GET --basic -u "$user:$password" -H "Accept: application/vnd.openlogic.olexgovernance+xml" "https://olex-secure.openlogic.com/loas/$loas" |perl -nle 'print $& if m{http(s?)://olex-secure.openlogic.com/licenses/[^ \"()\<>]*}' >licenselist-$loas.txt
   #get license id, license name
   while read i; do
    curl -X GET --basic -u "$user:$password" -H "Accept: application/vnd.openlogic.olexgovernance+xml" "${i}"|perl -nle 'print $& if m{(?<=<ol_license_id>).*(?=</ol_license_id>)} | m{(?<=<name>).*(?=</name>)}'| sed 's/^[ \t]*//;s/[ \t]*$//' | sed ':a;N;$!ba;s/\n/|/g' >>license-url-$loas.txt
   done <licenselist-$loas.txt
done
}
if [ "$choice" = "1" ]; then
echo "choice =1. To export PACKAGE_URL"
package $user $password $loass
else
echo "choice = 2.To export LICENSE and PACKAGE URL"
package $user $password $loass
license $user $password $loass
fi