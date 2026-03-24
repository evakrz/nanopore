
base_dir=/scratch/evakrzisnik/desiree_resequencing/16_gaqet
in_base=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs
out_base=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/outputs
yaml=$base_dir/scripts/config.yaml
#23. 3. gaqet runa samo s swissprot
#24. 3. imamo tudi ze trembl, je odkomentiran v config
mkdir -p "$out_base"

#run on gff3 files, generated from gff
for gff in "$in_base"/hap*_helixer.agat.gff3; do

    hap=$(basename "$gff" | sed 's/_helixer\.agat\.gff3$//')
    genome="$in_base/De_v2.${hap}.fa"
    name="De_v2.${hap}_helixer"

    echo "Starting $name"
    ls -l "$genome"
    ls -l "$gff"

    conda activate /users/timg/.conda/envs/gaqet
    GAQET \
      --yaml "$yaml" \
      -s "$name" \
      -g "$genome" \
      -a "$gff" \
      -t 4113 \
      -o "$out_base/$name"
    conda deactivate

done

# Plot gaqet reuslts
# Merge GAQET stats tables
dir="$out_base"
tsv=gaqet_results_merged.tsv

stats_files=$(find "$dir" -mindepth 2 -maxdepth 2 -name '*_GAQET.stats.tsv')

if [ -z "$stats_files" ]; then
    echo "No GAQET stats files found in $dir"
    exit 1
fi

awk 'NR==1 || FNR>1' $stats_files > "$dir/$tsv"

conda activate /users/timg/.conda/envs/gaqet
GAQET_PLOT \
  -i "$dir/$tsv" \
  -o "$dir/gaqet_results_merged.png"
conda deactivate
