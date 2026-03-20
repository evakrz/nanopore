in_base=/scratch/evakrzisnik/desiree_resequencing/16_helixer/inputs

mkdir -p $in_base

#ker so v 15/inputs faste z urejenimi imeni haplotipov in kromosomov, bomo črpali input od tam
cp /scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v2.hapgroup_a.fa \
   $in_base/De_v2.hap1.fa

cp /scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v2.hapgroup_b.fa \
   $in_base/De_v2.hap2.fa  

cp /scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v2.hapgroup_c.fa \
   $in_base/De_v2.hap3.fa   

cp /scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v2.hapgroup_d.fa \
   $in_base/De_v2.hap4.fa

gzip $in_base/De_v2.hap*.fa