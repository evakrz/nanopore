
# LUCA omark db is in /scratch/timg/desiree_annotation/omark/LUCA.h5
# for diamond uniprot swissprot and trembl fungi sets were downloaded from uniprot via API (they don't provide fastas anymore on FTP only their dat files...
#curl "https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=%28%28taxonomy_id%3A4751%29+AND+%28reviewed%3Atrue%29%29" --output fungi_uniprot_swissprot.fa.gz
# the trembl one is too big for direct download - it needs pagination (see download_fungi_uniprot_swissprot.sh)
# than make diamond db
conda activate /users/timg/.conda/envs/diamond
diamond makedb --in uniprot_swissprot_fungi.fa -d uniprot_swissprot_fungi
diamond makedb --in uniprot_trembl_fungi.fa -d uniprot_trembl_fungi
conda deactivate

# There was a typo in agat get longest isoform argument ("-gff" instead of "--gff") in /users/timg/.conda/envs/gaqet/lib/python3.10/site-packages/src/agat.py

base_dir=/scratch/timg/fusarium/comparative_genomics/1_annotation/QC

yaml=$base_dir/config.yaml




# Funannotate gffs
# There is some problem with some funann gffs, I can't idetify where. I'll try to just run AGAT with log on the files and see if this identifies the problem.
# Found the problem, funannotate keeps problematic genes, like the ones outside the genomic sequence (WHAT?!). You need to run funannotate fix to remove those....

#Fo.4287_011129	Unable to translate
#Fo.4287_011130	Feature inside gap of Ns
#Fo.4287_011131	Feature inside gap of Ns


fix_dir=/scratch/timg/fusarium/comparative_genomics/1_annotation/funannotate/Fusarium_oxysporum_lycopersici_refseq/predict_results
funannotate fix -i $fix_dir/Fusarium_oxysporum_4287.gbk \
-t $fix_dir/Fusarium_oxysporum_4287.tbl \
-d $fix_dir/models_to_remove.txt \
-o $fix_dir

for gff in /scratch/timg/fusarium/comparative_genomics/1_annotation/funannotate/*lycopersici_refseq/predict_results/*.gff3; do

name=$(basename -s .gff3 $gff)
in_dir=$(dirname $gff)

echo " Starting with genome $name"
ls -l $in_dir/$name.scaffolds.fa
ls -l $in_dir/$name.gff3

conda activate /users/timg/.conda/envs/gaqet
GAQET \
--yaml $yaml \
-s $name.funann \
-g $in_dir/$name.scaffolds.fa \
-a $gff \
-t 5507 \
-o $base_dir/$name.funann
conda deactivate

done

# BRAKER3 (prot evidence only mode) gff:

#convert gtfs to gffs

for braker_dir in /scratch/timg/fusarium/comparative_genomics/1_annotation/BRAKER3/*NIB01/; do

name=$(basename $braker_dir)

conda activate /users/timg/.conda/envs/agat
agat_convert_sp_gxf2gxf.pl \
-g ${braker_dir}braker.gtf \
-o ${braker_dir}$name.braker.gff
conda deactivate

done

for gff in /scratch/timg/fusarium/comparative_genomics/1_annotation/BRAKER3/*NIB01/*.braker.gff; do

name=$(basename -s .gff $gff)
in_dir=$(dirname $gff)

echo " Starting with genome $name"
ls -l $in_dir/*.masked.fa
ls -l $gff

conda activate /users/timg/.conda/envs/gaqet
GAQET \
--yaml $yaml \
-s $name \
-g $in_dir/*.masked.fa \
-a $gff \
-t 5507 \
-o $base_dir/$name
conda deactivate

done


# Plot gaqet reuslts

# merge table together
dir=/scratch/timg/fusarium/comparative_genomics/1_annotation/QC
tsv=gaqet_results_merged.tsv
awk 'NR==1 || FNR>1' \
$dir/*/*_GAQET.stats.tsv > \
$dir/$tsv

# I manually merged result into:

conda activate /users/timg/.conda/envs/gaqet
GAQET_PLOT \
-i $dir/$tsv \
-o $dir/gaqet_results_merged.png
conda deactivate