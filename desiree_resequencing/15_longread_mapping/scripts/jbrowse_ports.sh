#genomes=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/inputs

#pafs=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping/outputs



screen -R files_http

files=/scratch/evakrzisnik/desiree_resequencing/15_longread_mapping
file_port=6010
# cd v direktorij s fastami, npr:
cd $files
# Zazeni preprost http file ferver, da bodo faste dostopne preko networka
python3 -m http.server $file_port


ssh -L 6010:localhost:6010 evakrzisnik@egret.nib.si 