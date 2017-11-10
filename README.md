# python_merge_html
Python scripts to select specific data from different sources online into one csv file
## Instruction
This is the introduction on how to use the bash script and python script. There are two csv files and one html file as the examples of input for the python script.
First, run the bash script, export_package_url. Some txt files will be generated. Open ‘package-url.txt’, package id, package name and homepage will be found. We only need the package name and homepage. Then make a csv file, put the package name and homepage in this csv file, make it in the same format as the example ‘package_url.csv’. This csv will have the homepage information of all the packages.
Next, export ‘confirmed license text’ and ‘scan results’ from Olex. We need not revise them. The other two examples are exactly the exports from Olex. ‘olex_csv.csv’ file has the copyright and ‘licenses.html’ is the original html file we are going to merged with.
Final, run the Python script ‘Merge_HTML.py’. We will be asked to type those three file name. We should quote them, such as ‘olex_csv.csv’. Then a merged HTML file will be created in the same directory. There are some issues now. We have to delete ‘\n’ character in the link in the merged HTML file, and more manual works to clean the copyright is necessary. The revision of the python script will help us make more progress.
The output html file is named as New_file.

