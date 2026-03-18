input=/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/inputs/library3.fastq
output=/DKED/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs

conda activate seqkit

seqkit fx2tab $input > $output/fx2tab.tsv

seqkit fx2tab -l $input > $output/fx2tab_lengths.tsv

conda deactivate