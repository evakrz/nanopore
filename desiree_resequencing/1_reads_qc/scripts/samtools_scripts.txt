
#lokacija bam filea
#/DKED/scratch/evakrzisnik/desiree_resequencing/dorado/outputs/Evak_TG_08_11_2025_Desiree_resequencing/library_2/20250812_0939_MN43590_FBD50601_b6985a1a/bam_pass

#fastq : convert bam v fastq


#       Starting from a coordinate sorted file, output paired reads to  separate  files,  discarding  singletons,
#       supplementary and secondary reads.  The resulting files can be used with, for example, the bwa aligner.
#
#           samtools collate -u -O in_pos.bam | \
#           samtools fastq -1 paired1.fq -2 paired2.fq -0 /dev/null -s /dev/null -n

#       Starting  with  a  name  collated  file,  output  paired and singleton reads in a single file, discarding
#       supplementary and secondary reads.  To get all of the reads in a single file, it is necessary to redirect
#       the output of samtools fastq.  The output file is suitable for use with  bwa  mem  -p  which  understands
#       interleaved files containing a mixture of paired and singleton reads.
#
#           samtools fastq -0 /dev/null in_name.bam > all_reads.fq

#       Output  paired reads in a single file, discarding supplementary and secondary reads.  Save any singletons
#       in a separate file.  Append /1 and /2 to read names.  This format is suitable for use by NextGenMap  when
#       using  its  -p  and  -q  options.   With  this  aligner,  paired  reads  must be mapped separately to the
#       singletons.

#           samtools fastq -0 /dev/null -s single.fq -N in_name.bam > paired.fq

input_filepath="/scratch/evakrzisnik/desiree_resequencing/dorado/outputs/\
Evak_TG_08_11_2025_Desiree_resequencing/library_2/20250812_0939_MN43590_FBD50601_b6985a1a/bam_pass/\
FBD50601_bam_pass_b6985a1a_b44b57e0_0.bam"

output_dirpath="/scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs" 

#output izgleda tako: > output_dirpath/paired.fq
#ker bom mogoce imela locene paired in singletons, da zlahka specifyjam njuno lokacijo

#tole ni pravilen syntax! moras dat forslash in backslash skupaj pred newlineom, v bistvu samo insertas backslash
#samtools fastq /DKED/scratch/evakrzisnik/desiree_resequencing/dorado/outputs \
#    Evak_TG_08_11_2025_Desiree_resequencing/library_2/20250812_0939_MN43590_FBD50601_b6985a1a/bam_pass \
#    FBD50601_bam_pass_b6985a1a_b44b57e0_0.bam \
#    > \
#    /DKED/scratch/evakrzisnik/desiree_resequencing/reads_qc/outputs \
#    library2_paired.fastq

#ont ima samo single-end, paired je specifika za illumino

samtools fastq -@ 60 $input_filepath > $output_dirpath/library2.fastq 

cat $output_dirpath/library2.fastq | less
