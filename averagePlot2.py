import sys
from operator import add


# get the name of the file, which was passed to the script
fname = sys.argv[1]
#print fname

#the second argument is the text file with library size
libsizeFile = sys.argv[2]



# read the number in the text file with library size and upload it to the variable libsize
# this will be used for normalization
f = open(libsizeFile)
for line in iter(f):
    libsize = float(line)
f.close() #closes the text file


# read the bed file line by line- in each iteration add the values from the corresponding
# column to the previously obtained values, in the end ge the average by dividing the sum
# by the number of iterations

# initialize empty list helpAv, which will in the end contain the average values of
# each column
helpAv = []
f = open(fname)
i=1
for line in iter(f):
	# split the data by empty spaces
    data =([v for v in line.split()])
    # the numbers in each row are starting from 5th position
    cisla = map(float, data[4:])

	#if some region is for some reason shorter than predefined, e.g. end of chromosome
	# do not include this region to the sum
    if len(cisla) != int(sys.argv[3])*2+1:
        continue

	# in case of reversed strand flip the vector prior to sum
    if data[3] == '-':
        cisla.reverse()

	#do the sum in every iteration
    if i == 1:
        helpAv = cisla
    else:
        helpAv = map(add, helpAv, cisla)

    i = i+1
f.close() #closes the text file

#aveCoverage contains the average coverage
#norm coverage contains the values normalized by library size
aveCoverage = [x / (i-1) for x in helpAv]
normFactor = libsize / 10e6
normCoverage = [x / normFactor for x in aveCoverage]
normCoverage = ['{:.2f}'.format(x) for x in normCoverage]

# write the output values to meanNormCov.txt in tab delimited format

ID = sys.argv[4]
with open((ID + '_meanNormCov.txt'), 'w') as f:
    f.write('\t'.join(normCoverage[1:]) + '\n')
#print cisla
#print delka
#print aveCoverage
#print helpAv
#print (i-1)
#print helpAv
#print len(normCoverage)
