# Pairtools version
#
# pipeline based on https://omni-c.readthedocs.io
#mamba create -n omni-c -c bioconda -c conda-forge pairtools bwa-mem2 pysam tabulate bedtools matplotlib pandas samtools preseq  "numpy<1.24.0"


# semi-fixded variables
threads=100
out_base=/scratch/evakrzisnik/desiree_resequencing/omni-c_mapping/output
reads="/scratch/timg/desiree_seq/output/reads/desiree_hic_R1_raw.fastq /scratch/timg/desiree_seq/output/reads/desiree_hic_R2_raw.fastq"

mkdir -p $out_base
#_______________________________________________________________________________________________________
# CODE

for asm_path in /scratch/evakrzisnik/desiree_resequencing/contaminants_removal/output/*.decontaminated.fa; do

asm_name=$(basename -s .fa $asm_path)
out_dir=$out_base/$asm_name
asm=$out_dir/asm.fa
# prepare output direcotry
mkdir $out_dir
ln -s -f $asm_path $asm

# pre-alignment
conda activate omni-c
bwa index -a bwtsw $asm
samtools faidx $asm
cut -f1,2 $asm.fai > \
$asm.genome

# ALIGNMENT ONLY!
#bwa mem -5SP -T0 -t $threads $asm $reads > \
#$out_dir/mapped.bam
# params:
#-5            for split alignment, take the alignment with the smallest coordinate as primary
#-S            skip mate rescue
#-P            skip pairing; mate rescue performed unless -S also in use
#-T INT        minimum score to output [30]

# alignment and processing
bwa mem -5SP -T0 -t $threads $asm $reads > \
$out_dir/mapped.bam
pairtools parse \
--min-mapq 40 --walks-policy 5unique \
--max-inter-align-gap 30 --nproc-in $threads --nproc-out $threads \
--chroms-path $asm.genome \
--output-stats $out_dir/parse.stats \
$out_dir/mapped.bam | \
pairtools sort --nproc $threads | \
pairtools dedup --nproc-in $threads --nproc-out $threads --mark-dups \
--output-stats $out_dir/dedup.stats | \
pairtools split --nproc-in $threads --nproc-out $threads \
--output-pairs $out_dir/mapped.pairs --output-sam - | \
samtools view -bS -@ $threads | \
samtools sort -@ $threads -o $out_dir/mapped.PT.bam 
samtools index $out_dir/mapped.PT.bam

conda deactivate

done



# calculate bam stats
conda activate /users/timg/.conda/envs/mapping
for bam in $out_dir/*/*.bam
 do
  bam_name=$(basename -s.bam $bam)
  samtools stats -@ 20 $bam > $out_dir/$bam_name.stats
done
conda deactivate
# run multiqc
conda activate multiqc_pairtools
cd $out_dir
multiqc .
conda deactivate
#_______________________________________________________________________________________________________

