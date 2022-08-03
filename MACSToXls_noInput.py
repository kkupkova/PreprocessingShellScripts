""" Extracts all desired values from the MACS report text file
"""
# importing packages
from pandas import DataFrame #allows to create data frame from lists
import re #regular expressions
import os #to get the text file from current working directory

#gets the text file placed in the current working directory
cwd = os.getcwd()
for file in os.listdir(cwd):
    if file.endswith(".txt"):
        fname = file
# preseting empty lists which are used further in the script:
sample_ID = []
filter_tags = []
peaks = []

#the text file is read line by line, if the line contains an expression
#which is located on the same line with desired number, the numer is then extracted
# by use of regular expression
f = open(fname)
for line in iter(f):
    #get the sample ID
    if ('name =' in line):
        ID = line.split(" = ",1)[1].strip()
        sample_ID.append(ID)

    #get the number of tags after filtering
    elif('tags after filtering in treatment:' in line):
        cislo = re.findall('\d+', line)
        filter_tags.append(cislo[-1])

    #ge the number of both positive and negative peaks
    elif('peaks are called!' in line):
        cislo = re.findall('\d+', line)
        peaks.append(cislo[-1])

f.close() #closes the text file



# Transform the lists into one data frame table, so it can be transformed into an xlsx
# table. The heads in the data frame have numbers in front of the indicator in order to
# avoid the change of column positions alphabetically (normally it gets sorted, therefore
# we would end up with columns in unwanted order)
df = DataFrame({'01 # processed sample': sample_ID,
                '02 # MACS tags after filtering in treatment': map(int, filter_tags),
                '03 # MACS peaks in treatment': map(int, peaks)})

# this line gets the ID from the text file name (everything before . ), this
#allows to name the final xlsx file in accordance with the sample ID
ID = fname.rsplit('.',1)[0]
df.to_excel( (ID + '.xlsx'), sheet_name='sheet1', index=False)
