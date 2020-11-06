""" TxtToXls.py - this script obtains information from the final report obtained
by running batchtofastqc.sh or dmspikein.sh script. The order of the columns
is then the same like in the existing excel file.

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
fastq_name = []
total = []
one_time = []
one_time_p = []
more = []
more_p = []
zero = []
zero_p = []
alig_rate = []
total_mapped = []

#the text file is read line by line, if the line contains an expression
#which is located on the same line with desired number, the numer is then extracted
# by use of regular expression
f = open(fname)
for line in iter(f):
    if ('.fastq' in line):
        fastq_name.append(line.strip())

    #gets the number of processed reads - list named total
    if ('reads; of these:' in line):
        cislo = re.findall('\d+', line)
        total.append(cislo[0])

    #gets the number of the reads that aligned exactly one time - list named one_time
    #and the percentage of these reads - list named one_time_p
    elif('aligned exactly 1 time' in line):
        cislo = re.findall('\d+', line)
        one_time.append(cislo[0])

        cislo_p = cislo[1] + '.' + cislo[2]
        one_time_p.append(cislo_p)

    #gets the number of the reads that aligned more than one time - list named more
    #and the percentage of these reads - list named more_p
    elif('aligned >1 times' in line):
        cislo = re.findall('\d+', line)
        more.append(cislo[0])

        cislo_p = cislo[1] + '.' + cislo[2]
        more_p.append(cislo_p)

    #gets the number of the reads that aligned zero times - list named zero
    #and the percentage of these reads - list named zero_p
    elif ('aligned 0 times' in line):
        cislo = re.findall('\d+', line)
        zero.append(cislo[0])

        cislo_p = cislo[1] + '.' + cislo[2]
        zero_p.append(cislo_p)

    # gets the overall alignment rate and saves it into list - alig_rate
    elif ('overall alignment rate' in line):
        cislo = re.findall('\d+', line)
        cislo_p = cislo[0] + '.' + cislo[1]

        alig_rate.append(cislo_p)

    #if the line contains only numbers, this is where to look for the number of total
    #mapped reads, unmapped reds (these are eliminated by indexing, when the lists
    #are transformed to data frame), and mapped reads after removal of the blacklist
    #reads - outcome is the list named total_mapped
    elif line.rstrip().isdigit():
        total_mapped.append(line.rstrip())

f.close() #closes the text file

# edit the total mapped reads and blacklisted sites vectors -
# these occur only once vs the four values fpr each line
# 1) make empty lists
mapped_vector = [None] * len(one_time)
blacklisted_vector = [None] * len(one_time)
# 2) insert the correct values into the empty list
mapped_ind = range(0, len(total_mapped), 3)
mapped_vector_ind = range(3, len(mapped_vector), 4)

for i in range(0, len(mapped_vector_ind)):
    mapped_vector[mapped_vector_ind[i]] = total_mapped[mapped_ind[i]]
    blacklisted_vector[mapped_vector_ind[i]] = total_mapped[(mapped_ind[i]+2)]


# Transform the lists into one data frame table, so it can be transformed into an xlsx
# table. The heads in the data frame have numbers in front of the indicator in order to
# avoid the change of column positions alphabetically (normally it gets sorted, therefore
# we would end up with columns in unwanted order)


# print(len(fastq_name))
# print(total)
# print(one_time)
# print(one_time_p)
# print(more)
# print(more_p)
# print(zero)
# print(zero_p)
# print(alig_rate)
# print(mapped_vector)
# print(blacklisted_vector)
df = DataFrame({'01 processed fastq file': fastq_name,
                '02 # reads processed': map(int,total),
                '03 # reads that aligned exactly one time': map(int, one_time),
                '04 percent of reads that aligned exactly one time': map(float, one_time_p),
                '05 # reads that aligned more than one time': map(int, more),
                '06 percent of reads that aligned more than one time': map(float, more_p),
                '07 # reads that aligned zero times': map(int,zero),
                '08 percent of reads that aligned zero times': map(float, zero_p),
                '09 overall alignment rate': map(float, alig_rate),
                '10 total # of mapped reads': mapped_vector,
                '11 total # of mapped reads after blacklist filtering': blacklisted_vector})
# this line gets the ID from the text file name (everything before _ ), this
#allows to name the final xlsx file in accordance with the sample ID

ID = fname.rsplit('.',1)[0]
df.to_excel( (ID + '.xlsx'), sheet_name='sheet1', index=False)
