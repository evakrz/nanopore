

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

#pofiltrirano hifi bomo se enkrat pogledali z minimapom in R

conda activate minimap

threads=100
out_base=/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output
input_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input"

query=$input_base/timg_hifi_cleaned.fastq
target=$input_base/desiree_organelles.fa

output=$out_base/timg_hifi_cleaned_decontaminated.paf

minimap2 -x map-hifi -t $threads $target $query > $output

conda deactivate

#ont chopped library se enkat mapiramo

conda activate minimap

threads=100
out_base=/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output
input_base="/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input"

query=$input_base/timg_ont_chopper.fastq
target=$input_base/desiree_organelles.fa

output=$out_base/timg_ont_chopper_decontaminated.paf


minimap2 -x map-ont -t $threads $target $query > $output

conda deactivate


######################
#4. 3. 2026 določili kriterije za cutoff
#hifi, stara in nova ONT kemija svoji kriteriji
#zdaj seqkit grep za vse 4 knjiznice

input_base=/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input
out_base=/scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output
threads=40

original_hifi=$input_base/timg_hifi.fastq
original_lib2=$input_base/library2_filtered.fastq
original_lib3=$input_base/library3_filtered.fastq
original_old_ont=$input_base/timg_ont_chopper.fastq


conda activate seqkit

seqkit grep -j $threads -v -f $input_base/hifi_contaminant_ids.txt $original_hifi > $out_base/hifi.cleaned.fastq

seqkit grep -j $threads -v -f $input_base/lib2_contaminant_ids.txt $original_lib2 > $out_base/lib2.cleaned.fastq

seqkit grep -j $threads -v -f $input_base/lib3_contaminant_ids.txt $original_lib3 > $out_base/lib3.cleaned.fastq

seqkit grep -j $threads -v -f $input_base/oldont_contaminant_ids.txt $original_old_ont > $out_base/timg.ont.cleaned.fastq

#sanity check, should contain fewer reads after running
echo "===== HIFI ====="
seqkit stats $original_hifi
seqkit stats $out_base/hifi.cleaned.fastq

echo "===== LIBRARY 2 ====="
seqkit stats $original_lib2
seqkit stats $out_base/lib2.cleaned.fastq

echo "===== LIBRARY 3 ====="
seqkit stats $original_lib3
seqkit stats $out_base/lib3.cleaned.fastq

echo "===== OLD ONT ====="
seqkit stats $original_old_ont
seqkit stats $out_base/timg.ont.cleaned.fastq

conda deactivate

#sanity check outputs
# ===== HIFI =====
# file                                                                                            format  type   num_seqs         sum_len  min_len   avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input/timg_hifi.fastq  FASTQ   DNA   4,124,274  79,351,821,101      139  19,240.2   50,124
# file                                                                                                format  type   num_seqs         sum_len  min_len   avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output/hifi.cleaned.fastq  FASTQ   DNA   3,949,689  76,032,933,789      139  19,250.4   50,124

# ===== LIBRARY 2 =====
# file                                                                                                    format  type  num_seqs        sum_len  min_len   avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input/library2_filtered.fastq  FASTQ   DNA    239,749  3,404,361,671       19  14,199.7  483,373
# file                                                                                                format  type  num_seqs        sum_len  min_len  avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output/lib2.cleaned.fastq  FASTQ   DNA    239,438  3,403,125,004       19   14,213  483,373

# ===== LIBRARY 3 =====
# file                                                                                                    format  type  num_seqs        sum_len  min_len   avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input/library3_filtered.fastq  FASTQ   DNA    181,996  6,919,368,875       20  38,019.3  592,777
# file                                                                                                format  type  num_seqs        sum_len  min_len   avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output/lib3.cleaned.fastq  FASTQ   DNA    181,307  6,914,289,419       20  38,135.8  592,777

# ===== OLD ONT =====
# file                                                                                                   format  type  num_seqs        sum_len  min_len  avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/input/timg_ont_chopper.fastq  FASTQ   DNA    611,528  5,833,707,350        2  9,539.6  207,815
# file                                                                                                    format  type  num_seqs        sum_len  min_len  avg_len  max_len
# /scratch/evakrzisnik/desiree_resequencing/2_plastid_contaminants_removal/output/timg.ont.cleaned.fastq  FASTQ   DNA    556,052  5,517,528,509        2  9,922.7  207,815