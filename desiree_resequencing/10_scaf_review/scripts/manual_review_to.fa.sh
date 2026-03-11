# CODE iz timg manual jbat review dela

#outdir je nek review compiling lokacija
# VARIABLES
hap_num=hap2
review_id=review0

assembly_name=asm16

# DIRECTORIES
in_dir=/scratch/evakrzisnik/desiree_resequencing/10_scaf_review/input/$hap_num
out_dir=/scratch/evakrzisnik/desiree_resequencing/10_scaf_review/output/$hap_num

dgenies_dir=/scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/${hap_num}_scaf
yahs_dir=/scratch/evakrzisnik/desiree_resequencing/8_yahs/output/16.asm.$hap_num.p_ctg
assembly=/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/16/16.asm.$hap_num.p_ctg.fa

assembly_file=$in_dir/${hap_num}_yahs_jbat.$review_id.assembly
liftover_agp=$yahs_dir/yahs_jbat.liftover.agp

mkdir -p $in_dir
mkdir -p $out_dir
mkdir -p "$dgenies_dir"

# -------- SANITY CHECK FUNCTION --------

check_file () {
    if [[ -f "$1" ]]; then
        echo "✓ Found: $1"
    else
        echo "✗ Missing required file: $1"
        exit 1
    fi
}

# -------- CHECK INPUT FILES --------

echo "Checking required inputs..."

check_file "$assembly_file"
check_file "$liftover_agp"
check_file "$assembly"

echo "All required files found."

# -------- RUN JUICER POST --------

# conda activate yahs
# juicer post \
#  -o $out_dir/yahs_jbat.$review_id \
#  $in_dir/"$hap_num"_yahs_jbat.$review_id.assembly \
#  $yahs_dir/yahs_jbat.liftover.agp \
#  $assembly
# conda deactivate
# link to plots dir
#mkdir /scratch/timg/desiree_scaffolding/input/assemblies/$assembly_name

conda activate yahs

juicer post \
  -o "$out_dir/yahs_jbat.$review_id" \
  "$assembly_file" \
  "$liftover_agp" \
  "$assembly"

conda deactivate

# -------- VERIFY OUTPUT --------

final_fa="$out_dir/yahs_jbat.$review_id.FINAL.fa"

check_file "$final_fa"

# -------- LINK TO DGENIES --------

ln -sf "$final_fa" \
"$dgenies_dir/$assembly_name.$hap_num.yahs_jbat.$review_id.fa"

echo "✓ Symlink created:"
echo "$dgenies_dir/$assembly_name.$hap_num.yahs_jbat.$review_id.fa"

#ln -s $out_dir/yahs_jbat.$review_id.FINAL.fa /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/"$hap_num"_scaf/$assembly_name.yahs_jbat.$review_id.fa
#/scratch/timg/desiree_scaffolding/input/assemblies/$assembly_name/$assembly_name.yahs_jbat.$review_id.fa

