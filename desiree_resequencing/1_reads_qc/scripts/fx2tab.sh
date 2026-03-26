input=/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/inputs/library3.fastq
output=/DKED/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs

conda activate seqkit

seqkit fx2tab $input > $output/fx2tab.tsv

seqkit fx2tab -l $input > $output/fx2tab_lengths.tsv

conda deactivate


#run fx2tab on all my ont libraries for assembly in order to generate length histograms
lib2=/DKED/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/library2.fixedcrop_h20_t5_q10.fastq
lib3=/DKED/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/library3.fixedcrop_h20_t5_q10.fastq
libtim=/DKED/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs/chopper/timg_ont.fixedcrop_h35_t15_q10.fastq
output=/DKED/scratch/evakrzisnik/desiree_resequencing/1_reads_qc/outputs

conda activate seqkit

seqkit fx2tab -l $lib2 > $output/lib2_lengths.tsv
seqkit fx2tab -l $lib3 > $output/lib3_lengths.tsv
seqkit fx2tab -l $libtim > $output/lib_tim_lengths.tsv

conda deactivate