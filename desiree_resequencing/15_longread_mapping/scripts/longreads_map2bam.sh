in_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs

ver1=$in_base/De_v1.chrOnly.ver1.renamed.fa
ver2=$in_base/De_v2.chrOnly.ver2.renamed.fa

ont_reads=/scratch/evakrzisnik/desiree_resequencing/3_assembly/inputs/merged_ONT.fastq

out_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/outputs
mkdir -p "$out_base"

conda activate minimap
#map with no secondary alignments
minimap2 -x map-ont --secondary=no -t 100 -a \
  "$ver1" \
  "$ont_reads" \
  | samtools sort -o "$out_base/ONT_vs_v1.primary.bam"

samtools index "$out_base/ONT_vs_v1.primary.bam"

minimap2 -x map-ont --secondary=no -t 100 -a \
  "$ver2" \
  "$ont_reads" \
  | samtools sort -o "$out_base/ONT_vs_v2.primary.bam"

samtools index "$out_base/ONT_vs_v2.primary.bam"

#remove supplementary alignments
samtools view -F 0x800 -b \
  "$out_base/ONT_vs_v1.primary.bam" \
  > "$out_base/ONT_vs_v1.primary.noSuppl.bam"
samtools index "$out_base/ONT_vs_v1.primary.noSuppl.bam"

samtools view -F 0x800 -b \
  "$out_base/ONT_vs_v2.primary.bam" \
  > "$out_base/ONT_vs_v2.primary.noSuppl.bam"

samtools index "$out_base/ONT_vs_v2.primary.noSuppl.bam"

conda deactivate