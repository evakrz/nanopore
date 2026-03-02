

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

#######################################################
#MAR26
#korak takoj po qc odcitkov in chopperju, ze pred assemblyjem se zelimo znebiti odcitkov, ki mapirajo na organele

query="/scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs/chopper/library1.fixedcrop_h20_t5_q10.fastq"
target="/scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/input/desiree_organelles.fa" 

threads=100
out_base=/scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/output

conda activate minimap

output=$out_base/library3_decontaminated.paf
#preveri preden pozenes, kako bos imenovala library pri qc, 1 ali 3, in uporabljaj konsistentno

minimap2 -x map-ont -t $threads $target $query > $output

conda deactivate

#isto bomo dekontaminirali tudi HiFi odcitke izpred mojega prihoda, ki grejo tudi v assembly
query=""
target="/scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/input/desiree_organelles.fa" 

threads=100
out_base=/scratch/evakrzisnik/desiree_resequencing/plastid_contaminants_removal/output

conda activate minimap

output=$out_base/desiree_hifi_decontaminated.paf

#popravimo parameter, ker ne delamo vec z ont, ampak s pacbio hifi
minimap2 -x map-hifi -t $threads $target $query > $output

conda deactivate