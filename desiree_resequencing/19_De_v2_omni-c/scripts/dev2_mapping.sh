# Pairtools version
#
# pipeline based on https://omni-c.readthedocs.io
#mamba create -n omni-c -c bioconda -c conda-forge pairtools bwa-mem2 pysam tabulate bedtools matplotlib pandas samtools preseq  "numpy<1.24.0"
#conda create -n bwa -c bioconda -c conda-forge bwa
#conda install -c bioconda -c conda-forge samtools

# semi-fixded variables
threads=80
out_base=/scratch/evakrzisnik/desiree_resequencing/19_De_v2_omni-c/outputs
reads="/scratch/timg/desiree_seq/output/reads/desiree_hic_R1_raw.fastq /scratch/timg/desiree_seq/output/reads/desiree_hic_R2_raw.fastq"

mkdir -p $out_base

# CODE
asm_path=/scratch/evakrzisnik/desiree_resequencing/19_De_v2_omni-c/inputs/De_v2_chrs.fa
asm_name=$(basename -s .fa $asm_path)
out_dir=$out_base/$asm_name
asm=$out_dir/asm.fa
# prepare output direcotry
mkdir -p $out_dir
ln -s -f $asm_path $asm

# pre-alignment
conda activate omni-c
bwa index -a bwtsw $asm
samtools faidx $asm
cut -f1,2 $asm.fai > \
$asm.genome
conda deactivate
# ALIGNMENT ONLY!
#bwa mem -5SP -T0 -t $threads $asm $reads > \
#$out_dir/mapped.bam
# params:
#-5            for split alignment, take the alignment with the smallest coordinate as primary
#-S            skip mate rescue
#-P            skip pairing; mate rescue performed unless -S also in use
#-T INT        minimum score to output [30]

# alignment and processing
#bwa mem runs in its own env that we create with the latest bwa and samtools
conda activate bwa
#bwa mem -5SP -T0 -t $threads $asm $reads > \
#./bwa/bwa mem -SPu -t 5 mm10_EiJ_snpsonly.fa.gz test.1.fastq.gz test.2.fastq.gz | samtools view -@ 8 -b > mapped.XB.bam
bwa mem -SPu -t $threads $asm $reads | samtools view -@ 8 -b > $out_dir/mapped.XB.bam
#$out_dir/mapped.bam

conda deactivate

#_______________________________________________
#pocaka do naslednjic, mi samo pripravimo xb.bam
conda activate omni-c

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



#i changed the for loop in the mapping, from out_dir to out_base, if it doesnt work, check folder structure after it is finished.
# calculate bam stats
conda activate /users/timg/.conda/envs/mapping
for bam in $out_base/*/*.bam
 do
  bam_name=$(basename -s.bam $bam)
  samtools stats -@ 20 $bam > $out_dir/$bam_name.stats
done
conda deactivate
# run multiqc
conda activate /users/timg/.conda/envs/multiqc_pairtools
cd $out_dir
multiqc .
conda deactivate
#_______________________________________________________________________________________________________

