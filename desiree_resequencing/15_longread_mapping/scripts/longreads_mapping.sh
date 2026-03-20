in_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs

ver1=$in_base/De_v1.chrOnly.ver1.renamed.fa
ver2=$in_base/De_v2.chrOnly.ver2.renamed.fa

ont_reads=/scratch/evakrzisnik/desiree_resequencing/3_assembly/inputs/merged_ONT.fastq

out_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/outputs

conda activate minimap

minimap2 -x map-ont -t 8 \
  "$ver1" \
  "$ont_reads" \
  > "$out_base/ONT_vs_v1.paf"

minimap2 -x map-ont -t 8 \
  "$ver2" \
  "$ont_reads" \
  > "$out_base/ONT_vs_v2.paf"

conda deactivate
