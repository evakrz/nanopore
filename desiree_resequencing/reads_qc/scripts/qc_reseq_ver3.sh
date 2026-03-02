################################
#MAR 26 


conda activate nanopack

#input="/scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs/chopper/library2.filtered.fastq"
#new input=library from february sequencing, insert
#decide whether this is going to be called library 1 or 3, august library is lib2
input=""

output_base="/scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs"



subfolder="lib_feb_nanoplot"
output="$output_base"/"$subfolder"
mkdir -p $output
NanoPlot --fastq "$input" -o "$output"

subfolder="lib_feb_nanoqc"
output="$output_base"/"$subfolder"
mkdir -p $output
nanoQC "$input" -o "$output"



#input_filepath="/scratch/evakrzisnik/desiree_resequencing/reads_qc/inputs/library2.fastq"
#replace with library fastq file from february sequencing
input_filepath=""

#output_base="/scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs"
# Step 1: fixed crop
chopper \
  --trim-approach fixed-crop \
  --headcrop 20 \
  --tailcrop 5 \
  -t 8 \
  -i $input_filepath \
| chopper \
  --trim-approach quality \
  --cutoff 10 \
  -t 8 \
> /scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs/chopper/library1.fixedcrop_h20_t5_q10.fastq

conda deactivate
