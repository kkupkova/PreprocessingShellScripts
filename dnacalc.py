#!/usr/bin/env python
#This program takes a DNA sequence typed at the prompt (without checking) and shows its 
#length and nucleotide composition.  Case doesn't matter & spaces are ok.

#DNASeq = "ATGTCTCATTCAAAGCA"
DNASeq = raw_input("Enter a DNA sequence: ")
DNASeq = DNASeq.upper() #convert any lowercase characters to uppercase
DNASeq = DNASeq.replace(" ","") #get rid of any spaces in the input string

print 'Sequence:', DNASeq

#below are nested functions: first find the length, then make it float
SeqLength = float(len(DNASeq))

print 'Sequence Length:', SeqLength

NumberA=DNASeq.count('A')
NumberC=DNASeq.count('C')
NumberG=DNASeq.count('G')
NumberT=DNASeq.count('T')

#Calculate percentage and output to one decimal
print 'percent A: %.1f' % (100 * NumberA / SeqLength)
print 'percent C: %.1f' % (100 * NumberC / SeqLength)
print 'percent G: %.1f' % (100 * NumberG / SeqLength)
print 'percent T: %.1f' % (100 * NumberT / SeqLength)

#Calculate the primer melting points with different formulas by length

TotalStrong=NumberG + NumberC
TotalWeak=NumberA + NumberT

if SeqLength >=14:
	#formula for sequences 14 or more nucleotides long
	MeltTempLong=64.9 + 41*(TotalStrong - 16.4) / SeqLength
	print "Tm Long (>14): %.1f C" % (MeltTempLong)
else:
	#formula for sequences less than 14 nucleotides long	
	MeltTemp=(4*TotalStrong) + (2*TotalWeak)
	print "Melting Temp: %.1f C" % (MeltTemp)

