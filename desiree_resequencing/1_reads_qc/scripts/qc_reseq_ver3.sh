################################
#MAR 26 


conda activate nanopack

#input="/scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs/chopper/library2.filtered.fastq"
#new input=library from february sequencing, insert

input="/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/inputs/library3.fastq"

output_base="/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs"


subfolder="lib3_nanoplot"
output="$output_base"/"$subfolder"
mkdir -p $output
NanoPlot --fastq "$input" -o "$output"

subfolder="lib3_nanoqc"
output="$output_base"/"$subfolder"
mkdir -p $output
nanoQC "$input" -o "$output"



#input_filepath="/scratch/evakrzisnik/desiree_resequencing/reads_qc/inputs/library2.fastq"
#replace with library fastq file from february sequencing
#is a softlink from dorado outputs
input_filepath="/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/inputs/library3.fastq"

#output_base="/scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs"
# Step 1: fixed crop
#  chopper \
#    --trim-approach fixed-crop \
#    --headcrop 20 \
#    --tailcrop 5 \
#    -t 8 \
#    -i $input_filepath \
#  | chopper \
#    --trim-approach -quality \
#    --cutoff 10 \
#    -t 8 \
#  > /scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/library3.fixedcrop_h20_t5_q10.fastq


#odrezemo prvih 20 in zadnjih 5 nt, poleg tega pa obdrzimo samo tiste odcitke z average q score 10 ali vec
chopper \
  --trim-approach fixed-crop \
  --headcrop 20 \
  --tailcrop 5 \
  -q 10 \
  -t 8 \
  -i "$input_filepath" \
 > /scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/library3.fixedcrop_h20_t5_q10.fastq


input="/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/library3.fixedcrop_h20_t5_q10.fastq"

output_base="/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs"


subfolder="lib3_chopped_nanoplot"
output="$output_base"/"$subfolder"
mkdir -p $output
NanoPlot --fastq "$input" -o "$output"

subfolder="lib3_chopped_nanoqc"
output="$output_base"/"$subfolder"
mkdir -p $output
nanoQC "$input" -o "$output"


#hotela se preverit za tisto lib2, ki jo je choppal tim
input=/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/library2.filtered.fastq
output_base="/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs"


subfolder="lib2_chopped_nanoplot"
output="$output_base"/"$subfolder"
mkdir -p $output
NanoPlot --fastq "$input" -o "$output"

subfolder="lib2_chopped_nanoqc"
output="$output_base"/"$subfolder"
mkdir -p $output
nanoQC "$input" -o "$output"


#ta old reads timg library se cez headcrop, 35 head in 15 tail. trenutna verzija je samo q10, viden je deterioration kvalitete readov !!
input_filepath=/scratch/timg/desiree_seq/input/ont/desiree_ont_raw.fastq

chopper \
  --trim-approach fixed-crop \
  --headcrop 35 \
  --tailcrop 15 \
  -t 8 \
  -i "$input_filepath" \
 > /scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/timg_ont.fixedcrop_h35_t15_q10.fastq

input=/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/timg_ont.fixedcrop_h35_t15_q10.fastq
output_base="/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs"

subfolder="old_ont_h35t15q10_nanoplot"
output="$output_base"/"$subfolder"
mkdir -p $output
NanoPlot --fastq "$input" -o "$output"

subfolder="old_ont_h35t15q10_nanoqc"
output="$output_base"/"$subfolder"
mkdir -p $output
nanoQC "$input" -o "$output"


conda deactivate
