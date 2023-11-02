# takes GenBank files and extracts annotation and gene statistics information

# needs the BioPython toolbox
from Bio import SeqIO
import sys

# open files for IO
srcfile = sys.argv[1]

counter = 0
print("species,mtdna.length,cds.count.ncbi,trna.count.ncbi,rrna.count.ncbi,sum")
# go through records in the genbank file
for rec in SeqIO.parse(srcfile, "genbank"):
  counter = counter+1
  if rec.features:
    # we've found a suitable record -- grab the organism name
    if "organism" in rec.annotations:
      orgname = rec.annotations["organism"].replace(",", "_")
    else:
      orgname = "anon"
    rec_length = len(rec.seq)
    cds_count = sum(1 for feature in rec.features if feature.type == "CDS")
    trna_count = sum(1 for feature in rec.features if feature.type == "tRNA")
    rrna_count = sum(1 for feature in rec.features if feature.type == "rRNA")
    print(orgname+","+str(rec_length)+","+str(cds_count)+","+str(trna_count)+","+str(rrna_count)+","+str(cds_count+trna_count+rrna_count))

