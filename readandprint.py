#!/usr/bin/env python
#This simple program will open a text file, read each line one by one, split each line 
#into its tab-delimited elements, display each line or parts of lines to the screen as it is read & as indicated, then 
#close the file

#Set the input file name (run the program from within the directory containing the file)
InFileName = "Marrus_claudanielis.txt"

#Open the input file for reading
InFile = open(InFileName, 'r')

#Initialize the counter used to keep track of line numbers
#Starting at zero is the convention
LineNumber = 0

#Loop through each line in the file
for Line in InFile:
	#Skip the header (first line, number zero)
	if LineNumber > 0:
		#Remove the line-ending characters (it is good practice to strip them off so they 
		#don't interfere with later analyses)
		#for Windows files you would strip either end of the lines using 
		#Line.strip('\n').strip('\r')
		Line = Line.strip('\n')
		ElementList = Line.split('\t')
		#Use next statement to print the line, and note that print automatically adds back end of line characters (remove # to activate)
		#print LineNumber, ':', ElementList
		#Next line shows format for printing certain elements of each line & formatted so it is easy to read
		print "Depth: %s\tLat: %s\tLon: %s" % (ElementList[4], ElementList[2], ElementList[3])
	
	#Index the counter used to keep track of line numbers
	#Note not under control of if statement above so indented differently
	LineNumber = LineNumber + 1

#After the loop is completed, close the file and note that this is outside the for loop
InFile.close()