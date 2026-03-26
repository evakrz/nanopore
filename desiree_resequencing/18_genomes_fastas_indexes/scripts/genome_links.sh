desiree_base=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs
links=/scratch/evakrzisnik/desiree_resequencing/18_genomes_fastas_indexes/inputs

for f in "$desiree_base"/*.fa "$desiree_base"/*.fai; do
    [ -e "$f" ] || continue
    ln -s "$f" "$links/"
done