
output=/scratch/evakrzisnik/desiree_resequencing/9_chromosome_mapping/outputs

awk '/^>/ {header=substr($1,2)} /TTTAGGGTTTAGGGTTTAGGG/ {print header}' \
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/16/desiree_16.asm.hic.p_utg.fa \
| sort | uniq \
| tee "$output/telomere_unitigs.txt" \
| awk 'BEGIN{print "Name,Colour"} {print $1",#000000"}' > "$output/telomere_nodes_bandage.csv"

wc -l "$output/telomere_unitigs.txt"