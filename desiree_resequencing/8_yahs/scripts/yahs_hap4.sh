### VARIABLES

threads=20
out_base=/scratch/evakrzisnik/desiree_resequencing/8_yahs/output
extra_params="--no-contig-ec"

### SCRIPT

#we are going to run file by file, so the for loop is not relevant for now

#for asm in /scratch/evakrzisnik/desiree_resequencing/contaminants_removal/output/*.decontaminated.fa; do
#asm="path_to_decontaminated.fa"

#ver2: we decontaminated at read level, so we will use assembly level input.
asm=/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/16/16.asm.hap4.p_ctg.fa
asm_name=$(basename -s .fa $asm)
out_dir=$out_base/$asm_name
bam=/scratch/evakrzisnik/desiree_resequencing/6_omni-c_mapping/output/asm_16_hap4/mapped.PT.bam

mkdir -p $out_dir

# options to consider
#    --no-contig-ec    do not do contig error correction
#    --no-scaffold-ec  do not do scaffold error correction
#_______________________________________________________________________________________________________
# CODE
# for information about integration with JBAT go to https://github.com/c-zhou/yahs/blob/main/scripts/run_yahs.sh
# prepare output directory
# mkdir $out_dir                  #why twice? am guessing leftover from old code, commented out
# run yahs
conda activate yahs
#cd $out_dir
samtools faidx $asm

yahs \
 -o $out_dir/yahs \
 $extra_params \
 $asm \
 $bam

ln -s $out_dir/yahs_scaffolds_final.fa $out_base/$asm_name.yahs.fa

# run juicer pre to convert bin to hic for loading into JBAT
juicer pre -a -o $out_dir/yahs_jbat \
 $out_dir/yahs.bin \
 $out_dir/yahs_scaffolds_final.agp \
 $asm.fai > \
 $out_dir/yahs_jbat.log 2>&1

conda deactivate

conda activate java
java -Xmx500G -jar /users/timg/juicer_tools_1.22.01.jar pre \
 --threads $threads \
 $out_dir/yahs_jbat.txt \
 $out_dir/yahs_jbat.hic.part <(cat $out_dir/yahs_jbat.log | grep PRE_C_SIZE | awk '{print $2" "$3}')
conda deactivate
mv $out_dir/yahs_jbat.hic.part $out_dir/yahs_jbat.hic