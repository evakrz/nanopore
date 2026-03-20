

conda activate seqkit

in_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs

# seqkit replace \
#   -p '^v1_chr_(0[1-9]|1[0-2])_([1-4])$' \
#   -r 'chr_$1_v1_hap$2' \
#   $in_base/De_v1.chrOnly.ver1.fa \
#   -o $in_base/De_v1.chrOnly.ver1.renamed.fa

  seqkit replace \
  -p '^v1_chr_(0[1-9]|1[0-2])_([1-4])$' \
  -r 'chr_${1}_v1_hap${2}' \
  $in_base/De_v1.chrOnly.ver1.fa \
  -o $in_base/De_v1.chrOnly.ver1.renamed.fa


seqkit replace \
  -p '^v2_chr(0[1-9]|1[0-2])_([1-4])$' \
  -r 'chr_${1}_v2_hap${2}' \
  $in_base/De_v2.chrOnly.ver2.fa \
  -o $in_base/De_v2.chrOnly.ver2.renamed.fa

#   seqkit replace \
#   -p '^v2_chr(0[1-9]|1[0-2])_([1-4])$' \
#   -r 'chr_$1_v2_hap$2' \
#   $in_base/De_v2.chrOnly.ver2.fa \
#   -o $in_base/De_v2.chrOnly.ver2.renamed.fa


ls -lh /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v1.chrOnly.ver1.fa

seqkit seq -n $in_base/De_v1.chrOnly.ver1.fa | head -20
seqkit seq -n $in_base/De_v2.chrOnly.ver2.fa | head -20

seqkit seq -n $in_base/De_v1.chrOnly.ver1.renamed.fa | head -20
seqkit seq -n $in_base/De_v2.chrOnly.ver2.renamed.fa | head -20

#######we have established a consistent naming pattern between the versions!
#chr_01_v1_hap1
#chr_01_v2_hap1

######now we split the ver2 into 4 haplotypes
input=$in_base/De_v2.chrOnly.ver2.renamed.fa

seqkit grep -r -p '_hap1$' "$input" -o "$in_base/De_v2.hapgroup_a.fa"
seqkit grep -r -p '_hap2$' "$input" -o "$in_base/De_v2.hapgroup_b.fa"
seqkit grep -r -p '_hap3$' "$input" -o "$in_base/De_v2.hapgroup_c.fa"
seqkit grep -r -p '_hap4$' "$input" -o "$in_base/De_v2.hapgroup_d.fa"

#####all outputs 12 - correct
seqkit seq -n "$in_base/De_v2.hapgroup_a.fa" | wc -l
seqkit seq -n "$in_base/De_v2.hapgroup_b.fa" | wc -l
seqkit seq -n "$in_base/De_v2.hapgroup_c.fa" | wc -l
seqkit seq -n "$in_base/De_v2.hapgroup_d.fa" | wc -l

############now we will collect version 1 chromosomes from the corresponding haplotypes
#haplogroup a
cat > "$in_base/hapgroup_a_v1_ids.txt" <<'EOF'
chr_01_v1_hap1
chr_02_v1_hap2
chr_03_v1_hap1
chr_04_v1_hap1
chr_05_v1_hap1
chr_06_v1_hap1
chr_07_v1_hap1
chr_08_v1_hap1
chr_09_v1_hap2
chr_10_v1_hap1
chr_11_v1_hap2
chr_12_v1_hap4
EOF

seqkit grep \
  -f "$in_base/hapgroup_a_v1_ids.txt" \
  "$in_base/De_v1.chrOnly.ver1.renamed.fa" \
  -o "$in_base/De_v1.hapgroup_a.fa"

seqkit seq -n "$in_base/De_v1.hapgroup_a.fa"

#haplogroup b
cat > "$in_base/hapgroup_b_v1_ids.txt" <<'EOF'
chr_01_v1_hap2
chr_02_v1_hap4
chr_03_v1_hap2
chr_04_v1_hap2
chr_05_v1_hap2
chr_06_v1_hap2
chr_07_v1_hap3
chr_08_v1_hap2
chr_09_v1_hap1
chr_10_v1_hap2
chr_11_v1_hap3
chr_12_v1_hap2
EOF

seqkit grep \
  -f "$in_base/hapgroup_b_v1_ids.txt" \
  "$in_base/De_v1.chrOnly.ver1.renamed.fa" \
  -o "$in_base/De_v1.hapgroup_b.fa"

seqkit seq -n "$in_base/De_v1.hapgroup_b.fa"
seqkit seq -n "$in_base/De_v1.hapgroup_b.fa" | wc -l

#haplogroup c

cat > "$in_base/hapgroup_c_v1_ids.txt" <<'EOF'
chr_01_v1_hap4
chr_02_v1_hap1
chr_03_v1_hap3
chr_04_v1_hap3
chr_05_v1_hap3
chr_06_v1_hap4
chr_07_v1_hap2
chr_08_v1_hap3
chr_09_v1_hap4
chr_10_v1_hap3
chr_11_v1_hap1
chr_12_v1_hap3
EOF

seqkit grep \
  -f "$in_base/hapgroup_c_v1_ids.txt" \
  "$in_base/De_v1.chrOnly.ver1.renamed.fa" \
  -o "$in_base/De_v1.hapgroup_c.fa"

seqkit seq -n "$in_base/De_v1.hapgroup_c.fa"

#haplogroup d
cat > "$in_base/hapgroup_d_v1_ids.txt" <<'EOF'
chr_01_v1_hap3
chr_02_v1_hap3
chr_03_v1_hap4
chr_04_v1_hap4
chr_05_v1_hap4
chr_06_v1_hap3
chr_07_v1_hap4
chr_08_v1_hap4
chr_09_v1_hap3
chr_10_v1_hap4
chr_11_v1_hap4
chr_12_v1_hap1
EOF

seqkit grep \
  -f "$in_base/hapgroup_d_v1_ids.txt" \
  "$in_base/De_v1.chrOnly.ver1.renamed.fa" \
  -o "$in_base/De_v1.hapgroup_d.fa"

seqkit seq -n "$in_base/De_v1.hapgroup_d.fa"

###########extracting .bed files for contig ends
seqkit locate -p 'N{200}' -r --bed "$in_base/De_v1.hapgroup_a.fa" > "$in_base/De_v1.hapgroup_a.gaps.bed"
seqkit locate -p 'N{200}' -r --bed "$in_base/De_v1.hapgroup_b.fa" > "$in_base/De_v1.hapgroup_b.gaps.bed"
seqkit locate -p 'N{200}' -r --bed "$in_base/De_v1.hapgroup_c.fa" > "$in_base/De_v1.hapgroup_c.gaps.bed"
seqkit locate -p 'N{200}' -r --bed "$in_base/De_v1.hapgroup_d.fa" > "$in_base/De_v1.hapgroup_d.gaps.bed"

seqkit locate -p 'N{200}' -r --bed "$in_base/De_v2.hapgroup_a.fa" > "$in_base/De_v2.hapgroup_a.gaps.bed"
seqkit locate -p 'N{200}' -r --bed "$in_base/De_v2.hapgroup_b.fa" > "$in_base/De_v2.hapgroup_b.gaps.bed"
seqkit locate -p 'N{200}' -r --bed "$in_base/De_v2.hapgroup_c.fa" > "$in_base/De_v2.hapgroup_c.gaps.bed"
seqkit locate -p 'N{200}' -r --bed "$in_base/De_v2.hapgroup_d.fa" > "$in_base/De_v2.hapgroup_d.gaps.bed"

head "$in_base/De_v1.hapgroup_a.gaps.bed"
wc -l "$in_base/De_v1.hapgroup_a.gaps.bed"