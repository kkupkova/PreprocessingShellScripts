#!/usr/bin/env python
#This simple program will is supposed to open a text file, check to see if the output file already exists so as not to overwrite anything, then read each line one by one, split each line into its tab-delimited elements, write certain elements to a file, then close the file.  Doesn't work yet....

#Set the input file name (run the program from within the directory containing the file)
InFileName = "Marrus_claudanielis.txt"

#Check to see if the output file already exists
import os
if (os.path.isfile ('InFileName')):
	print("Output file already exists")
else:

#Open the input file for reading
InFile = open(InFileName, 'r')

#Initialize the counter used to keep track of line numbers; starting at zero is the convention
LineNumber = 0

#Open the output file for writing; do this *before* the loop, not inside it  Note that this specifies the file type as well (suffix)
OutFileName=InFileName + ".kml"

OutFile=open(OutFileName,'w') #You can append with 'a' rather than 'w'

#Loop through each line in the file
for Line in InFile:
	#Skip the header (first line, number zero)
	if LineNumber > 0:
		#Remove the line-ending characters (it is good practice to strip them off so they don't interfere with later analyses)
		#for Windows files you would strip either end of the lines using 
		#Line.strip('\n').strip('\r')
		Line = Line.strip('\n')
		
		#Separate the line into a list of its tab-delimited components
		ElementList=Line.split('\t')
		
		#Use the % operator to generate a string, and this can be used to output both to the screen and to a file
		OutputString = "Depth: %s\tLat: %s\t Lon: %s" % (ElementList[4], ElementList[2], ElementList[3])
		
		#Print to screen; use for debugging, otherwise turn off
		print OutputString
		
		#To write to file, need to linefeed
		OutFile.write(OutputString+"\n")
	
	#Index the counter used to keep track of line numbers
	#Note not under control of if statement above so indented differently
	LineNumber = LineNumber + 1

#After the loop is completed, close the files and note that this is outside the for loop
InFile.close()
OutFile.close()