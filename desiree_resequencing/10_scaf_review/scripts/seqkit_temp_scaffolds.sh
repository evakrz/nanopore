#vzeto moramo preset stevilo scaffoldov iz latest review.fa filea, in iz njih narediti nov temp file
#variables so haplotip, review file number in scaffold grep number


#VARIABLES
hap_num=hap4
review_id=review3
scaffold_num=13

out_dir=/scratch/evakrzisnik/desiree_resequencing/10_scaf_review/output/$hap_num
dgenies_dir=/scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/seqkit_temp

mkdir -p $dgenies_dir

final_fa=$out_dir/yahs_jbat.$review_id.FINAL.fa

temp_fa=$out_dir/$review_id.seqkit_temp.$scaffold_num.fa

conda activate seqkit
#seqkit head -n 10 review.fa > subset.fa
seqkit head -n $scaffold_num $final_fa > $temp_fa

conda deactivate

#SEQKIT SANITY CHECK
if [ ! -s "$temp_fa" ]; then
  echo "ERROR: temp fasta is empty"
  exit 1
fi


# -------- LINK TO DGENIES --------
ln -sf "$temp_fa" \
"$dgenies_dir/$hap_num.yahs_jbat.$review_id.seqkit_temp.$scaffold_num.fa"

echo "✓ Symlink created:"
echo "$dgenies_dir/$hap_num.yahs_jbat.$review_id.seqkit_temp.$scaffold_num.fa"