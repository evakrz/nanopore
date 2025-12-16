

#dekontaminacija libraryja iz avgusta za generiranje testnega paf filea

# ln -s /scratch/timg/tmp/desiree_organelles.fa \
#       /scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/input/desiree_organelles.fa
#tega na koncu nismo uporabili, ker je osnovna datoteka na tmpjih in sem si skopirala actual datoteko pod to ime


# ln -s /scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs/chopper/library2.filtered.fastq \
#       /scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/input/library2_filtered.fastq


# #ustvarimo svoj env za alignment
# conda create -n minimap -c bioconda minimap2 



#variables
threads=100
out_base=/scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/output



conda activate minimap


#vzamemo ze filtriran library z dobro kvaliteto nukleotidov

# minimap2 automatically detects FASTQ vs FASTA by file extension and format
query="/scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/input/library2_filtered.fastq"
target="/scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/input/desiree_organelles.fa" 

output=$out_base/library2_decontaminated.paf

#  * Long-read overlap without CIGAR:

#     minimap2 -x ava-ont [-t nThreads] target.fa query.fa > output.paf 


# If target.fa is a reference genome/assembly/contigs → use -x map-ont

# If target.fa is actually reads in FASTA form and you’re doing overlaps → use -x ava-ont

minimap2 -x map-ont -t $threads $target $query > $output

conda deactivate