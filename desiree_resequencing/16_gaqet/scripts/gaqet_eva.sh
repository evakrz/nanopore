# prepare env and check
conda create -n agat -c bioconda -c conda-forge agat -y
conda activate agat
agat_convert_sp_gxf2gxf.pl --help
conda deactivate


# prepare fasta files
in_base=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/

mkdir -p $in_base

#ker so v 15/inputs faste z urejenimi imeni haplotipov in kromosomov, bomo črpali input od tam
ln -s /scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v2.hapgroup_a.fa \
   $in_base/De_v2.hap1.fa

ln -s /scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v2.hapgroup_b.fa \
   $in_base/De_v2.hap2.fa  

ln -s /scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v2.hapgroup_c.fa \
   $in_base/De_v2.hap3.fa   

ln -s /scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs/De_v2.hapgroup_d.fa \
   $in_base/De_v2.hap4.fa

###########convert our .gff files from helixer to .gff3 (expected input)
conda activate agat

for gff in /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/hap*_helixer.gff; do
    out="${gff%.gff}.agat.gff3"
    echo "Converting $gff -> $out"
    agat_convert_sp_gxf2gxf.pl -g "$gff" -o "$out"
done
#we had an issue with a non gzipped hap1 that didn't have chromosomes labeled correctly. 
#always use gzipped files when submitting to helixer
#we generate a gff3 from this hap additionally and we rerun gaqet
gff=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/hap1_helixer.gff
out="${gff%.gff}.agat.gff3"
echo "Converting $gff -> $out"
agat_convert_sp_gxf2gxf.pl -g "$gff" -o "$out"

conda deactivate   

# LUCA omark db is in /scratch/timg/desiree_annotation/omark/LUCA.h5
# for diamond uniprot swissprot and trembl fungi sets were downloaded from uniprot via API (they don't provide fastas anymore on FTP only their dat files...
#curl "https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=%28%28taxonomy_id%3A4751%29+AND+%28reviewed%3Atrue%29%29" --output fungi_uniprot_swissprot.fa.gz
# the trembl one is too big for direct download - it needs pagination (see download_fungi_uniprot_swissprot.sh)
# than make diamond db
conda activate /users/timg/.conda/envs/diamond
cd /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/
pwd
# wget -O uniprot_trembl_eudicots.fa \
# "https://rest.uniprot.org/uniprotkb/stream?format=fasta&query=(taxonomy_id:71240)%20AND%20(reviewed:false)"
# wget -O uniprot_trembl_plants.fa.gz \
# "https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=(taxonomy_id:33090)%20AND%20(reviewed:false)"
# wget -O uniprot_trembl_plants.fa \
# 'https://rest.uniprot.org/uniprotkb/stream?format=fasta&query=%28taxonomy_id%3A33090%29%20AND%20%28reviewed%3Afalse%29'
# Error messages
# Too many results to retrieve. Please refine your query or consider fetching batch by batch


# recommended short version
# Swiss-Prot plants (works fine)
wget -O uniprot_swissprot_plants.fa \
'https://rest.uniprot.org/uniprotkb/stream?format=fasta&query=%28taxonomy_id%3A33090%29%20AND%20%28reviewed%3Atrue%29'

# TrEMBL (have to use loop because of file size)
#goes page by page and pastes the next input into the file until it builds the whole thing)
base='https://rest.uniprot.org/uniprotkb/search?query=%28taxonomy_id%3A71240%29%20AND%20%28reviewed%3Afalse%29&format=fasta&size=500'
out='uniprot_trembl_plants.fa'
tmp_headers='headers.txt'

: > "$out"
url="$base"

while [ -n "$url" ]; do
  echo "Downloading chunk..."
  curl -L --compressed -D "$tmp_headers" "$url" >> "$out"

  url=$(grep -i '^link:' "$tmp_headers" | sed -n 's/.*<\(.*\)>; rel="next".*/\1/p')
done

rm -f "$tmp_headers"

# build DIAMOND DBs
diamond makedb --in uniprot_swissprot_plants.fa -d uniprot_swissprot_plants #created
diamond makedb --in uniprot_trembl_plants.fa -d uniprot_trembl_plants #not created, for now commented out in config

# tim version
# diamond makedb --in uniprot_swissprot_fungi.fa -d uniprot_swissprot_fungi
# diamond makedb --in uniprot_trembl_fungi.fa -d uniprot_trembl_fungi
conda deactivate

# There was a typo in agat get longest isoform argument ("-gff" instead of "--gff") in /users/timg/.conda/envs/gaqet/lib/python3.10/site-packages/src/agat.py




# Funannotate gffs
# There is some problem with some funann gffs, I can't idetify where. I'll try to just run AGAT with log on the files and see if this identifies the problem.
# Found the problem, funannotate keeps problematic genes, like the ones outside the genomic sequence (WHAT?!). You need to run funannotate fix to remove those....

#Fo.4287_011129	Unable to translate
#Fo.4287_011130	Feature inside gap of Ns
#Fo.4287_011131	Feature inside gap of Ns

#my version
#run gaqet from here when you have all gff3 files ready

base_dir=/scratch/evakrzisnik/desiree_resequencing/16_gaqet
in_base=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs
out_base=/scratch/evakrzisnik/desiree_resequencing/16_gaqet/outputs
yaml=$base_dir/scripts/config.yaml
#23. 3. gaqet runa samo s swissprot
#od 24. 3. imamo tudi trembl v config, to bo final verzija
mkdir -p "$out_base"

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


######### AGAT ENV GFF3 TEST
conda activate agat

agat_convert_sp_gxf2gxf.pl \
  -g /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/hap4_helixer.gff \
  -o /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/hap4_helixer.agat.gff3

conda deactivate

conda activate /users/timg/.conda/envs/gaqet

GAQET \
  --yaml /scratch/evakrzisnik/desiree_resequencing/16_gaqet/scripts/config.yaml \
  -s De_v2.hap4_helixer \
  -g /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/De_v2.hap4.fa \
  -a /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/hap4_helixer.agat.gff3 \
  -t 4113 \
  -o /scratch/evakrzisnik/desiree_resequencing/16_gaqet/outputs/De_v2.hap4_helixer

conda deactivate


### tests of the agat pipeline, do not use in main gaqet function
conda activate agat

mkdir /scratch/evakrzisnik/desiree_resequencing/16_gaqet/outputs/test_split

agat_sp_separate_by_record_type.pl \
  --gff /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/hap4_helixer.agat.gff3 \
  -o /scratch/evakrzisnik/desiree_resequencing/16_gaqet/outputs/test_split

agat_sp_separate_by_record_type.pl \
  --gff /scratch/evakrzisnik/desiree_resequencing/16_gaqet/inputs/hap4_helixer.agat.gff3 \
  -o /scratch/evakrzisnik/desiree_resequencing/16_gaqet/outputs/test_split2
# # merge table together
# dir=$out_base
# tsv=gaqet_results_merged.tsv
# awk 'NR==1 || FNR>1' \
# $dir/*/*_GAQET.stats.tsv > \
# $dir/$tsv

# # I manually merged result into:

# conda activate /users/timg/.conda/envs/gaqet
# GAQET_PLOT \
# -i $dir/$tsv \
# -o $dir/gaqet_results_merged.png
# conda deactivate