
# run 1 De haps 1-4
csv=/scratch/timg/desiree_annotation/syri/input/De_v1_haps.csv
threads=60

# prepare dirs
run_name=$(basename -s.csv $csv)
out_base=/scratch/timg/desiree_annotation/syri/output
#in_dir=/scratch/timg/desiree_annotation/syri/input
out_dir=$out_base/$run_name
mkdir $out_dir
cd $out_dir

# convert to unix EOL
conda activate dos2unix
dos2unix $csv
conda deactivate

# Mapping
while IFS=, read asm name; do
 ln -s $asm $name.fa
done < $csv

# create array of names
mapfile -t names < <(cut -d, -f2 $csv)

# loop trough sequeintial asms pairs and map 
conda activate mapping
for ((i=0; i<${#names[@]}-1; i++)); do
  minimap2 -ax asm5 -t $threads --eqx \
  "${names[i]}".fa "${names[i+1]}".fa | \
  samtools sort -o "${names[i]}"_"${names[i+1]}".bam
done
conda deactivate

# Run syri on pairs
conda activate syri
for ((i=0; i<${#names[@]}-1; i++)); do
syri \
-c "${names[i]}"_"${names[i+1]}".bam \
-r "${names[i]}".fa -q "${names[i+1]}".fa \
-F B --prefix "${names[i]}"_"${names[i+1]}"
done

# plot
plotsr \
--sr hap1_hap2syri.out \
--sr hap2_hap3syri.out \
--sr hap3_hap4syri.out \
--genomes genomes.txt \
--tracks tracks.txt \
-o plot_anno.png

$genomes.txt
#file	name	tags
hap1.fa	hap1	lw:1.5;lc:#384259
hap2.fa	hap2	lw:1.5;lc:#F73859
hap3.fa	hap3	lw:1.5;lc:#7AC7C4
hap4.fa	hap4	lw:1.5;lc:#C4EDDE

lc = line colour

# add tracks
ln -s /scratch/timg/desiree_annotation/jbrowse_data/datarepo_dir/annotations/individual_haplotypes/De_v1_hap1.loci.gff .
ln -s /scratch/timg/desiree_annotation/jbrowse_data/datarepo_dir/annotations/individual_haplotypes/De_v1_hap1.repeats.gff .
ln -s /scratch/timg/desiree_annotation/jbrowse_data/datarepo_dir/annotations/individual_haplotypes/De_v1_hap1.functional_annotations.gff .

# tracks.txt
# file	name	tags
De_v1_hap1.loci.gff	Loci	ft:gff;bw:10000;nc:black;ns:8;nf:Arial;lc:blue;lw:4;bc:lightblue;ba:0.5
De_v1_hap1.repeats.gff	Repeats	ft:gff;bw:10000;nc:black;ns:8;nf:Arial;lc:sienna;lw:1;bc:peachpuff;ba:0.5