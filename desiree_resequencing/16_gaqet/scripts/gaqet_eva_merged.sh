base_dir=/scratch/evakrzisnik/desiree_resequencing/16_gaqet
in_base=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs
out_base=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/outputs
yaml=$base_dir/scripts/config.yaml
#23. 3. gaqet runa samo s swissprot
#od 24. 3. imamo tudi trembl v config, to bo final verzija
mkdir -p "$out_base"

#merged files
# /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v1_merged_helixer.gff
# /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v2_merged_helixer.gff

#corresponding fasta files
# /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v1_merged.fa
# /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v2_merged.fa

# #we run this twice, without loops

# #version 1
# gff=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v1_merged_helixer.gff
# genome=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v1_merged.fa

# #check that chromosome names match since we just renamed them now in the gff
# # comm -3 \
# #   <(cut -f1 "$gff" | grep -v '^#' | sort -u) \
# #   <(grep '^>' "$genome" | sed 's/^>//' | cut -d' ' -f1 | sort -u)
# # we got an empty output which means no differences

# hap=$(basename "$gff" | sed 's/_helixer\.agat\.gff3$//')
#     genome="$in_base/De_v2.${hap}.fa"
#     name="De_v2.${hap}_helixer"

#     echo "Starting $name"
#     ls -l "$genome"
#     ls -l "$gff"

#     conda activate gaqet
#     GAQET \
#       --yaml "$yaml" \
#       -s "$name" \
#       -g "$genome" \
#       -a "$gff" \
#       -t 4113 \
#       -o "$out_base/$name"
#     conda deactivate


# #version 2
# gff=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v2_merged_helixer.gff
# genome=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v2_merged.fa

# hap=$(basename "$gff" | sed 's/_helixer\.agat\.gff3$//')
#     genome="$in_base/De_v2.${hap}.fa"
#     name="De_v2.${hap}_helixer"

#     echo "Starting $name"
#     ls -l "$genome"
#     ls -l "$gff"

#     conda activate gaqet
#     GAQET \
#       --yaml "$yaml" \
#       -s "$name" \
#       -g "$genome" \
#       -a "$gff" \
#       -t 4113 \
#       -o "$out_base/$name"
#     conda deactivate


# joined in a loop
conda activate gaqet

for version in v1 v2; do
    gff="/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_${version}_merged_helixer.gff"
    genome="/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_${version}_merged.fa"
    name="De_${version}_merged_helixer"

    echo "Starting $name"
    ls -l "$genome" "$gff" || exit 1

    GAQET \
      --yaml "$yaml" \
      -s "$name" \
      -g "$genome" \
      -a "$gff" \
      -t 4113 \
      -o "$out_base/$name"
done

conda deactivate

# for gff in "$in_base"/*merged_helixer.gff; do

#     hap=$(basename "$gff" | sed 's/_helixer\.agat\.gff3$//')
#     genome="$in_base/De_v2.${hap}.fa"
#     name="De_v2.${hap}_helixer"

#     echo "Starting $name"
#     ls -l "$genome"
#     ls -l "$gff"

#     conda activate /users/timg/.conda/envs/gaqet
#     GAQET \
#       --yaml "$yaml" \
#       -s "$name" \
#       -g "$genome" \
#       -a "$gff" \
#       -t 4113 \
#       -o "$out_base/$name"
#     conda deactivate

# done

# Plot gaqet reuslts
# Merge GAQET stats tables
dir="$out_base"
tsv=v1v2_gaqet_results_merged.tsv

stats_files=$(find "$dir" -mindepth 2 -maxdepth 2 -name '*_GAQET.stats.tsv')

if [ -z "$stats_files" ]; then
    echo "No GAQET stats files found in $dir"
    exit 1
fi

awk 'NR==1 || FNR>1' $stats_files > "$dir/$tsv"

conda activate gaqet
GAQET_PLOT \
  -i "$dir/$tsv" \
  -o "$dir/v1v2_gaqet_results_merged.png"
conda deactivate

#rerun after it finishes to create a new more correct merged tsv with only 2 whole genomes
awk 'NR==1 || FNR>1' \
  "$out_base/De_v1_merged_helixer/De_v1_merged_helixer_GAQET.stats.tsv" \
  "$out_base/De_v2_merged_helixer/De_v2_merged_helixer_GAQET.stats.tsv" \
  > "$out_base/v1v2_gaqet_results_merged.tsv"

#copy everything timg has in tmp into my own gaqet outputs
rsync -avh --progress /DKED/scratch/timg/tmp/gaqet/outputs/ \
                       /scratch/evakrzisnik/desiree_resequencing/16_gaqet/outputs/