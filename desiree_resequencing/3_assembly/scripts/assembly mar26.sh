######################## assembly 16
# !!! hifiasm version 
#Hifiasm-0.25.0-r726
asm_version=16
out_dir=/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_version
input_base=/scratch/evakrzisnik/desiree_resequencing/3_assembly/inputs
threads=40
# create out dir
mkdir $out_dir
# activate conda env with 0.25 version

conda activate hifiasm

cat \
 $input_base/timg_ont_cleaned.fastq \
 $input_base/lib2_cleaned.fastq \
 $input_base/lib3_cleaned.fastq \
 > $input_base/merged_ONT.fastq

# paramters reference:
#https://hifiasm.readthedocs.io/en/latest/parameter-reference.html#hi-c-integration-options
# -s parameter:
#-s <FLOAT=0.55>
# Similarity threshold for duplicate haplotigs that should be purged. In default, 0.75 for -l1/-l2, 0.55 for -l3. 


#run same command as last time, just add the merged ONT libraries to the list of reads

hifiasm \
    -t $threads \
    -o $out_dir/desiree_$asm_version.asm \
    $input_base/hifi_cleaned.fastq \
    --h1 /scratch/timg/desiree_seq/output/reads/desiree_hic_R1_raw.fastq \
    --h2 /scratch/timg/desiree_seq/output/reads/desiree_hic_R2_raw.fastq \
    --ul $input_base/merged_ONT.fastq \
    --hom-cov 95 \
    --n-hap 4 > \
    $out_dir/desiree_$asm_version.log
conda deactivate



conda activate /users/timg/.conda/envs/gfatools
# Convert gfas to fastas
for file in $out_dir/*.gfa; do
    # Check if the file does not end with "noseq.gfa"
    if [[ "$file" != *noseq.gfa ]]; then
        # Extract file name without extension
        file_name=$(basename "$file" .gfa)
        # Perform conversion using gfatools
        gfatools gfa2fa $file > $out_dir/$file_name.fa
        echo "Converted $file to ${out_dir}${file_name}.fa"
    fi
done
conda deactivate

# add "_hapX" to the contig fasta header
conda activate /users/timg/.conda/envs/seqkit
for hap in 1 2 3 4
 do
  cat $out_dir/desiree_$asm_version.asm.hic.hap"$hap".p_ctg.fa | \
  seqkit replace -p $ -r _hap"$hap" > \
  $out_dir/$asm_version.asm.hap"$hap".p_ctg.fa
done
conda deactivate
# merge haplotypes
cat $out_dir/$asm_version.asm.hap*.p_ctg.fa > \
    $out_dir/$asm_version.asm.hap_all.p_ctg.fa