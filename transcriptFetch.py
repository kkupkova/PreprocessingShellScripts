import re

#print("This program will retrieve gene names (if defined) in a stringtie annotation gtf file")
#print("and associate them with deseq2 results listing stringtie transcript results")
#print("Note that if there is no gene name for a transcript, then the gene name will be")
#print("NA in the results file")
#print("Use a .txt file with deseq2 significant hits only")
#print("For the gtf, use the stringtie_merged.gtf obtained from the stringtie pipeline")

#this program will retrieve the gene names contained in an annotation
#file in gtf format using as input a list of StringTie TRANSCRIPT names
#note that this program would need to be modified slightly for differential effects using genes and not transcripts

#for testing use these
#master_list = open("test.gtf") #list of all transcripts in gtf format
#deseq2_results = open("test_results.txt") #single column of StringTie transcripts

deseq2_input = raw_input("What's the name of the input file with significant DESeq2 results? \n")
master_file = raw_input("What's the name of the input master gft file? \n")
output_file = raw_input("What do you want to call the results file (prefix)? \n")
results_file = open(output_file + ".txt","w")

deseq2_results = open(deseq2_input)
master_list = open(master_file)

print("Reading data in: " + str(deseq2_input))
print("Reading data in: " + str(master_file))

results_file.write("transcript"+"\t"+"baseMean"+"\t"+"log2FC"+"\t"+"padj"+"\t"+"gene_name"+"\t"+"chrom"+"\t"+"start"+"\t"+"stop"+"\n")

#define dictionary that will hold MSTRG ID as key and entire deseq2 result string as value
#define dictionary that will hold MSTRG ID as key and gene_name, if present as value
#use deseq2 results file in same format as originally saved, just tab-delimited, and only input significant genes of interest
deseq2_dict = {}
gtf_dict ={}
MSTR_ID_list = set()

#read through the deseq2 file line by line and add the data to the dict
#use the next two lines to skip the first line header, then process lines after that
with deseq2_results as f:
    next(f)
    for line in deseq2_results:
        line_data = line.strip("\n").split("\t")
        #print(line_data)
        MSTR_ID = str(line_data[0])
        padj = str(line_data[6])
        log2FC = str(line_data[2])
        MSTR_ID_list.add(MSTR_ID)
        deseq2_dict[MSTR_ID] = line_data

#this definition will search for the value (v) associated with a query key (k)
#this is used to extract the gene_name corresponding to the MSR_ID
def search(keys, searchFor):
    for k in keys:
        for v in keys[k]:
            if searchFor in v:
                return k
    return None

#now go through the gft file line by line and if the transcript name matches a name in the deseq2 dict,
#then add it to the gtf dict
for line in master_list:
    transcript = line.strip("\n")
    if not transcript.startswith("#"): #skip the initial comment lines
        segments = transcript.split("\t")
        mainID = segments[2] 
        if mainID == str("transcript"): #determine whether the line is for a transcript or an exon
            chromosome = segments[0]
            start = segments[3]
            stop = segments[4]
            assocID = segments[8]
            segments2 = assocID.split()
            #print(str(segments2))
            mstrg_id = segments2[3] #this identifies the stringtie transcript name
            mstrg_search = re.search('\"(.+)\"\;',str(mstrg_id)) #this reformats the stringtie gene name
            #if mstrg_search:
            mstrg_reformat = mstrg_search.group(1)
            #print(mstrg_reformat)
            if search (deseq2_dict,mstrg_reformat):
                gtf_dict[mstrg_reformat] = segments

for name in MSTR_ID_list:
    deseq2_result = deseq2_dict[name]
    gtf_result =gtf_dict[name]
    combined = deseq2_result + gtf_result
    if "gene_name" in str(combined):
        transcript = combined[0]
        baseMean = combined[1]
        log2FC = combined[2]
        padj = combined[6]
        chrom = combined[7]
        start = combined[10]
        stop = combined[11]
        gene_name_item = combined[15]
        gni_split = gene_name_item.split()
        gene_name = gni_split[5]
        gene_name_reformat = re.search('\"(.+)\"\;',gene_name)
        gene_name_final=gene_name_reformat.group(1)
        #print(str(combined[0])+"\t"+str(combined[1])+"\t"+str(combined[2])+"\t"+str(combined[6])+"\t"+str(gene_name_final)+"\t"+str(combined[7])+"\t"+str(combined[10])+"\t"+str(combined[11]))
        results_file.write(str(combined[0])+"\t"+str(combined[1])+"\t"+str(combined[2])+"\t"+str(combined[6])+"\t"+str(gene_name_final)+"\t"+str(combined[7])+"\t"+str(combined[10])+"\t"+str(combined[11])+"\n")
    else:
        #print(str(combined[0])+"\t"+str(combined[1])+"\t"+str(combined[2])+"\t"+str(combined[6])+"\t"+"NA"+"\t"+str(combined[7])+"\t"+str(combined[10])+"\t"+str(combined[11]))
        results_file.write(str(combined[0])+"\t"+str(combined[1])+"\t"+str(combined[2])+"\t"+str(combined[6])+"\t"+"NA"+"\t"+str(combined[7])+"\t"+str(combined[10])+"\t"+str(combined[11]+"\n"))
        
print("Done!")
                     
results_file.close()       

#print("first:")
#for i in deseq2_dict:
    #print i, deseq2_dict[i] 
            
#print("second:")
#for i in gtf_dict:
    #print i, gtf_dict[i] 
