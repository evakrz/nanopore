############ REMOVAL OF CONTAMINATED CONTIGS 

# I installed blast conda env from file at /scratch/timg/blast_conda_env.yaml

# SET ASSEMBLLY VARIABLES
asm_version=15


#### CODE
# fixed variables
threads=100
blast_outdir="/scratch/evakrzisnik/desiree_resequencing/contaminants_removal/output/blast"
blast_dbs=/scratch/timg/blast_dbs
est_genome_size=750000000
out_dir=/scratch/evakrzisnik/desiree_resequencing/contaminants_removal/output


mkdir -p $blast_outdir
mkdir /scratch/evakrzisnik/desiree_resequencing/contaminants_removal/output/window_masker

for hap in 1 2 3 4; do

asm=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/$asm_version/$asm_version.asm.hap$hap.p_ctg.fa
asm_name=$(basename -s.fa $asm)
masked_db=/scratch/evakrzisnik/desiree_resequencing/contaminants_removal/output/window_masker/"$asm_name"_masked

# RUN WINDOWMASKER on assembly for bacterial blast search
# mask assembly
conda activate blast

windowmasker -mk_counts -sformat obinary -genome_size $est_genome_size -mem 500000 \
-in $asm \
-out $masked_db

# RUN BLAST
mkdir $blast_outdir/$asm_name
# loop over 4 blast databases
for db_name in rDNA_solanum_2023-07-17 chloroplasts_solanum_2.1_2023-07-17 chloroplasts_solanum_1.1_2023-07-17 mitochondira_solanum_1.1_2023-07-17
 do
  blastn \
  -task megablast -outfmt "6 qseqid sseqid length qlen" -num_threads $threads \
  -query $asm \
  -db $blast_dbs/$db_name \
  -out $blast_outdir/$asm_name/"$db_name"_results.txt
 done
 
# do blast search for bacteria contamination separetly with masked assemblly
db_name="bacteria_refseq_2023-07-17"
blastn -task megablast -outfmt "6 qseqid sseqid length qlen" -num_threads $threads \
-window_masker_db $masked_db \
-query $asm \
-db $blast_dbs/$db_name \
-out $blast_outdir/$asm_name/"$db_name"_results.txt
conda deactivate

# GET CONTAMINATED CONTIGS NAMES
# filter contig names with high enough mathes one by one
# rDNA Solanum
db_name="rDNA_solanum_2023-07-17"
python /scratch/timg/desiree_scaffolding/blast_results_filter.py \
$blast_outdir/$asm_name/"$db_name"_results.txt \
-p 10 \
-o $blast_outdir/$asm_name/"$db_name"_filtered_contig_names.txt
# chloroplasts 2.1
db_name="chloroplasts_solanum_2.1_2023-07-17"
python /scratch/timg/desiree_scaffolding/blast_results_filter.py \
$blast_outdir/$asm_name/"$db_name"_results.txt \
--max-size 500000 \
-p 20 \
-o $blast_outdir/$asm_name/"$db_name"_filtered_contig_names.txt
# chloroplasts 1.1
db_name="chloroplasts_solanum_1.1_2023-07-17"
python /scratch/timg/desiree_scaffolding/blast_results_filter.py \
$blast_outdir/$asm_name/"$db_name"_results.txt \
--max-size 500000 \
-p 20 \
-o $blast_outdir/$asm_name/"$db_name"_filtered_contig_names.txt
# mitochondrion 1.1
db_name="mitochondira_solanum_1.1_2023-07-17"
python /scratch/timg/desiree_scaffolding/blast_results_filter.py \
$blast_outdir/$asm_name/"$db_name"_results.txt \
--max-size 1000000 \
-p 20 \
-o $blast_outdir/$asm_name/"$db_name"_filtered_contig_names.txt
# bacteria refseq
db_name="bacteria_refseq_2023-07-17"
python /scratch/timg/desiree_scaffolding/blast_results_filter.py \
$blast_outdir/$asm_name/"$db_name"_results.txt \
-p 10 \
-o $blast_outdir/$asm_name/"$db_name"_filtered_contig_names.txt
# concatenate all and deduplicate
cat $blast_outdir/$asm_name/*_filtered_contig_names.txt | \
sort |uniq > \
$blast_outdir/$asm_name/merged_filtered_contig_names.txt
# STATS - write number of lines (contigs) for each file
for file in $(find $blast_outdir/$asm_name/. -type f -name "*filtered_contig_names.txt"); do
    filename=$(basename "$file")
    num_lines=$(wc -l < "$file")
    echo -e "$num_lines\t\t$filename" >> $blast_outdir/$asm_name/contigs_filtered.txt
done


# REMOVE CONTAMINATED CONTIGS
conda activate /users/timg/.conda/envs/seqkit
# Write ribosomal contigs
db_name="rDNA_solanum_2023-07-17"
seqkit grep \
-f $blast_outdir/$asm_name/"$db_name"_filtered_contig_names.txt \
$asm > \
$blast_outdir/$asm_name/ribosomal_ctgs.fa
# remove all matches including rDNA
seqkit grep -v \
-f $blast_outdir/$asm_name/merged_filtered_contig_names.txt \
$asm > \
$blast_outdir/$asm_name/filtered_by_merged.fa
# add rDNA contigs back to fasta
cat $blast_outdir/$asm_name/filtered_by_merged.fa \
$blast_outdir/$asm_name/ribosomal_ctgs.fa > \
$blast_outdir/$asm_name/decontaminated_asm.fa
# link
ln -s $blast_outdir/$asm_name/decontaminated_asm.fa \
$out_dir/"$asm_name".decontaminated.fa

conda deactivate

done

# STATS - basic stats on assemblies before/after filtering
seqkit stat -b -a \
/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/$asm_version/$asm_version.asm.hap*.p_ctg.fa \
$blast_outdir/*/decontaminated_asm.fa > \
$blast_outdir/filtering_stats.txt
conda deactivate


#______________________________________________________________________________________________________________________________________________________