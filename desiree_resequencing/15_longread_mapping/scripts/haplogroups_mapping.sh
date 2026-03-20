conda activate minimap

in_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs
out_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/outputs

mkdir -p "$out_base"

minimap2 -x asm5 -t 8 \
  "$in_base/De_v2.hapgroup_a.fa" \
  "$in_base/De_v1.hapgroup_a.fa" \
  > "$out_base/De_hapgroup_a_v2_vs_v1.paf"

minimap2 -x asm5 -t 8 \
  "$in_base/De_v2.hapgroup_b.fa" \
  "$in_base/De_v1.hapgroup_b.fa" \
  > "$out_base/De_hapgroup_b_v2_vs_v1.paf"

minimap2 -x asm5 -t 8 \
  "$in_base/De_v2.hapgroup_c.fa" \
  "$in_base/De_v1.hapgroup_c.fa" \
  > "$out_base/De_hapgroup_c_v2_vs_v1.paf"

minimap2 -x asm5 -t 8 \
  "$in_base/De_v2.hapgroup_d.fa" \
  "$in_base/De_v1.hapgroup_d.fa" \
  > "$out_base/De_hapgroup_d_v2_vs_v1.paf"

conda deactivate


conda activate minimap

in_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs
out_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/outputs
#just in case, we create .bam files also
# hapgroup A
minimap2 -x asm5 -t 20 -a \
  "$in_base/De_v2.hapgroup_a.fa" \
  "$in_base/De_v1.hapgroup_a.fa" \
  | samtools sort -o "$out_base/De_hapgroup_a_v2_vs_v1.bam"

samtools index "$out_base/De_hapgroup_a_v2_vs_v1.bam"

# hapgroup B
minimap2 -x asm5 -t 20 -a \
  "$in_base/De_v2.hapgroup_b.fa" \
  "$in_base/De_v1.hapgroup_b.fa" \
  | samtools sort -o "$out_base/De_hapgroup_b_v2_vs_v1.bam"

samtools index "$out_base/De_hapgroup_b_v2_vs_v1.bam"

# hapgroup C
minimap2 -x asm5 -t 20 -a \
  "$in_base/De_v2.hapgroup_c.fa" \
  "$in_base/De_v1.hapgroup_c.fa" \
  | samtools sort -o "$out_base/De_hapgroup_c_v2_vs_v1.bam"

samtools index "$out_base/De_hapgroup_c_v2_vs_v1.bam"

# hapgroup D
minimap2 -x asm5 -t 20 -a \
  "$in_base/De_v2.hapgroup_d.fa" \
  "$in_base/De_v1.hapgroup_d.fa" \
  | samtools sort -o "$out_base/De_hapgroup_d_v2_vs_v1.bam"

samtools index "$out_base/De_hapgroup_d_v2_vs_v1.bam"  

conda deactivate

