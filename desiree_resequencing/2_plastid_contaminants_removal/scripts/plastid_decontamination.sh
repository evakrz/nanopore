

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
out_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output"
input_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input"


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

#variables
threads=100
out_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output"
input_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input"


conda activate minimap

query=$input_base/library3_filtered.fastq
target=$input_base/desiree_organelles.fa


output=$out_base/library3_decontaminated.paf


minimap2 -x map-ont -t $threads $target $query > $output


#enako z starimi odcitki desiree od Tima
#variables
threads=100
out_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output"
input_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input"

query=$input_base/timg_ont.fastq
target=$input_base/desiree_organelles.fa

output=$out_base/timg_ont_decontaminated.paf


minimap2 -x map-ont -t $threads $target $query > $output

#isto bomo dekontaminirali tudi HiFi odcitke izpred mojega prihoda, ki grejo tudi v assembly

threads=100
out_base=/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output
input_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input"

query=$input_base/timg_hifi.fastq
target=$input_base/desiree_organelles.fa

output=$out_base/timg_hifi_decontaminated.paf

#popravimo parameter, ker ne delamo vec z ont, ampak s pacbio hifi

minimap2 -x map-hifi -t $threads $target $query > $output

conda deactivate

#zdaj se preselimo v okolje R
#.paf datoteke, ki smo jih pridobili, bomo nesli naprej in jih analizirali
#.paf datoteke si scp-jam na komp, od koder bomo delali naprej 
#vrnemo se sem z dolocenim thresholdom za filtriranje in filtriranje samo
conda create -n seqkit -c bioconda -c conda-forge seqkit

#za hifi se kar odlocim za cutoff, to naredim in se enkrat zmapiram in plotam
input_base=/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input
out_base=/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output

original_hifi=$input_base/timg_hifi.fastq

conda activate seqkit

seqkit grep -v -f $input_base/hifi_contaminant_ids.txt $original_hifi > $out_base/hifi.cleaned.fastq

#sanity check, should contain fewer reads after running
seqkit stats $original_hifi
seqkit stats $out_base/hifi.cleaned.fastq

conda deactivate

#output za hifi:
# [INFO] 200116 patterns loaded from file
# file                                                                                            format  type   num_seqs         sum_len  min_len   avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input/timg_hifi.fastq  FASTQ   DNA   4,124,274  79,351,821,101      139  19,240.2   50,124
# file                                                                                                format  type   num_seqs         sum_len  min_len   avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output/hifi.cleaned.fastq  FASTQ   DNA   3,924,158  75,523,358,034      139  19,245.7   50,124
