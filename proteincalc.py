#!/usr/bin/env python
#This program takes a protein sequence in single letter code and determines its 
#molecular weight
#The look up table was generated from a web page through regular expression replacements

AminoDict={
'A':89.09,
'R':174.20,
'N':132.12,
'D':133.10,
'C':121.15,
'Q':146.15,
'E':147.13,
'G':75.07,
'H':155.16,
'I':131.17,
'L':131.17,
'K':146.19,
'M':149.21,
'F':165.19,
'P':115.13,
'S':105.09,
'T':119.12,
'W':204.23,
'Y':181.19,
'V':117.15,
'X':0.0,
'-':0.0,
'*':0.0
}

#Input protein sequence string on the command line.
ProteinSeq = raw_input("Enter a protein sequence in single letter code: ")
ProteinSeq = ProteinSeq.upper() #convert any lowercase characters to uppercase

MolWeight = 0

#Step through each amino acid, setting the amino acid variable to its value
for AminoAcid in ProteinSeq:

	#look up the value corresponding to the current amino acid
	#add its value to the running total
	MolWeight = MolWeight + AminoDict[AminoAcid]

#Once the loop is completed, print the protein sequence and the molecular weight	
print "Protein Sequence: ", ProteinSeq
print "Molecular Weight: %.1f" % (MolWeight)
