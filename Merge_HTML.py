import csv #nice module for writing out to csv files
from bs4 import BeautifulSoup
import codecs
import sys

olex_file = input("Please enter the file name of the scan results ")
olex = open(olex_file,'r')
csv_f = csv.reader(olex)
csv_reader = list(csv_f)

url_olex = input("Please enter the file name of the package url ")
url_open = open(url_olex,'r')
url_f = csv.reader(url_open)
url_reader = list(url_f)

html_file = open("New_file.html",'w')


def split_copyrights(copyrights,package_name,shortcopy_package):
    copy_list = copyrights.split('//')
    copy_content = ""
    for each_copyright in copy_list:
        index_search1 = 0
        index_search2 = 9
        if('Copyright' in each_copyright):
            while index_search1 < len(each_copyright):
                index_copyright1 = each_copyright.find('Copyright',index_search1)
                index_copyright2 = each_copyright.find('Copyright',index_search2)
                if index_copyright1 != -1 and index_copyright2 == -1:
                    revised_copy = each_copyright[index_copyright1:]
                elif index_copyright1 == -1:
                    break
                else:
                    revised_copy = each_copyright[index_copyright1:index_copyright2-1]
##                revised_copy = revised_copy.split(',')[0]
##                revised_copy = revised_copy.split('.')[0]
                revised_copy = revised_copy.replace('*','')
                revised_copy = revised_copy.replace('#','')
                if not shortcopy_package.has_key(revised_copy):
                    shortcopy_package[revised_copy] = package_name
                    copy_content = copy_content + '<p>' + revised_copy + '</p>'
                index_search1 += 9
                index_search2 += 9
    return copy_content

def get_url(package_name, package_url):
    for row in package_url:
        if row[0] in package_name:
            print 'find it!'
            return '<p><a href="'+row[1]+'" target="_blank">'+row[0]+'</a></p>'

    return '<p>'+package_name+'</p><p>No homepage</p>'

def get_html(filename):
    f = codecs.open(filename, 'r', 'utf-8')
    t = f.read()
    tt = BeautifulSoup(t,'html.parser')
    unicode.join(u'\n',map(unicode,tt))
    
    part0 = (str(tt).split('<section>'))[0]

    for row in tt.findAll('section'):
       part1 = (str(row.findAll('a'))).split('<h1>')[0]
       license_id = part1.replace('<a name="',"").replace('">',"").replace('[','')
       part2 = str(row.findAll('h1')).replace('[','').replace(']','')
       license_name = part2.replace("<h1><li>","").replace("</li></h1>","").replace("[","").replace("]","")
       part3 = (str(row).split('</h1>'))[1]
       part4 = '<section><a name="' + license_id + '">'
       part0 = part0 + part4 + part2 + '<h2>Following packages are under this license: </h2>'
       map_package = dict()
       for line in csv_reader:
           if license_name in line[7] and not map_package.has_key(line[6]):
               package_name = line[6]
               copy_package = dict()
               shortcopy_package = dict()
               part5 = get_url(package_name, url_reader)
               map_package[line[6]] = license_name
               part0 = part0 + part5
               for line in csv_reader:
                   if line[6]==package_name and line[9]!="" and not copy_package.has_key(line[9]):
                       part6 = split_copyrights(line[9],package_name,shortcopy_package)
                       part0 = part0 + part6
                       copy_package[line[9]] = line[6]
       part0 = part0 + part3
    part0 = part0 + '</ol>' + '</body>' + '</html>'
    html_file.write(part0)
    html_file.close()
##       print license_id
##       print license_name
##       print type(part1)
##       print type(part2)
##       print type(part3)
##       print part1 + part2 + part3
    f.close()

html_olex = input("Please enter the file name of the license html file ")
get_html(html_olex)
