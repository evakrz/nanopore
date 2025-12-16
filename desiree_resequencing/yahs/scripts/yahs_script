# YaHS version
# 1.2a.1


###SETUP


### env installation

#java env installation
conda env create --file /scratch/timg/java_conda_env.yaml
# check env name to activate it later
cat /scratch/timg/java_conda_env.yaml

#check conda env installation
conda activate java
which java
conda deactivate

#yahs installation
conda env create --file /scratch/timg/yahs_conda_env.yaml

#check conda env installation
conda activate yahs
which yahs
conda deactivate


###check jar permissions
conda activate java
JAR=/users/timg/juicer_tools_1.22.01.jar
java -jar "$JAR" --help
conda deactivate

#____________________________________________________________________________________________________________

### VARIABLES

threads=60
out_base=/scratch/evakrzisnik/desiree_resequencing/yahs/output
#extra_params="--no-contig-ec"


### SCRIPT

#we are going to run file by file, so the for loop is not relevant for now

#for asm in /scratch/evakrzisnik/desiree_resequencing/contaminants_removal/output/*.decontaminated.fa; do
asm="path_to_decontaminated.fa"

asm_name=$(basename -s .fa $asm)
out_dir=$out_base/$asm_name
bam=/scratch/timg/desiree_scaffolding/omni-c_mapping/output/$asm_name/mapped.PT.bam  #a tukej tudi eventuelno uporabimo moje bam? JA
bam="path_to_same_hap_as_decontaminated_mapped.pt.bam"

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
# yahs
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
java -jar -Xmx500G /users/timg/juicer_tools_1.22.01.jar pre \
--threads $threads \
$out_dir/yahs_jbat.txt \
$out_dir/yahs_jbat.hic.part <(cat $out_dir/yahs_jbat.log | grep PRE_C_SIZE | awk '{print $2" "$3}')
conda deactivate
mv $out_dir/yahs_jbat.hic.part $out_dir/yahs_jbat.hic
#_______________________________________________________________________________________________________


#naprej je leftover from old code?? run to HERE
















# ngi orginial command:
(java -jar -Xmx230G /vulpes/proj/ngis/ngi2016004/private/remi/opt/juicer_tools_1.22.01.jar pre out_JBAT.txt out_JBAT.hic.part <(cat out_JBAT.log  | grep PRE_C_SIZE | awk '{print $2" "$3}')) && (mv out_JBAT.hic.part out_JBAT.hic)
# try witgh older version and higher memory, ERROR was out of memory and it looks liek it needs a lot of memory with so many threads
java -jar -Xmx500G /DKEC/users/timg/juicer_tools_1.22.01.jar pre \
--threads $threads \
$out_dir/yahs_jbat.txt \
$out_dir/yahs_jbat.hic.part <(cat $out_dir/yahs_jbat.log | grep PRE_C_SIZE | awk '{print $2" "$3}')
conda deactivate
mv $out_dir/yahs_jbat.hic.part $out_dir/yahs_jbat.hic
This worked, it would probably also work with newer juicer tools version, just needs more ram






















conda activate java
java -jar -Xmx32G /DKEC/users/timg/juicer_tools.2.20.00.jar pre \
/DKED/scratch/timg/desiree_scaffolding/yahs/output/yahs_jbat.txt \
/DKED/scratch/timg/desiree_scaffolding/yahs/output/out_JBAT.hic.part <(cat /DKED/scratch/timg/desiree_scaffolding/yahs/output/ont_only_flye_01_asm_decontaminated_polished.yahs_jbat.log | grep PRE_C_SIZE | awk '{print $2" "$3}')
conda deactivate
mv /DKED/scratch/timg/desiree_scaffolding/yahs/output/out_JBAT.hic.part /DKED/scratch/timg/desiree_scaffolding/yahs/output/out_JBAT.hic




juicer pre -a -o $out_dir/yahs_jbat \
$out_dir.bin \
"$out_dir"_scaffolds_final.agp \
$asm.fai > \
$out_dir.yahs_jbat.log 2>&1# YaHS version
# 1.2a.1

### VARIABLES

#_______________________________________________________________________________________________________
# run ont only flye decont asm
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/ont_only_flye_01_asm_decontaminated_polished.fa
#_______________________________________________________________________________________________________
# run hifiasm07 purged decont hap2
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/desiree_07.asm.hic.hap2.p_ctg_decontaminated_purged/purged_ends_modified_desiree_07.asm.hic.hap2.p_ctg_decontaminated.fa
#_______________________________________________________________________________________________________
# run hifiasm07 purged decont hap1
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/desiree_07.asm.hic.hap1.p_ctg_decontaminated_purged/purged_ends_modified_desiree_07.asm.hic.hap1.p_ctg_decontaminated.fa
#_______________________________________________________________________________________________________
# run hifiasm01 hap1
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/desiree_01.asm.bp.hap1.p_ctg.fa
# try without error correction step to avoid breaking contigs
extra_params="--no-scaffold-ec"
#_______________________________________________________________________________________________________
# run hifiasm01 hap2
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/desiree_01.asm.bp.hap2.p_ctg.fa
#_______________________________________________________________________________________________________
# run hifiasm01 hap1 curated
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/desiree_01.asm.bp.hap1.p_ctg/desiree_01.asm.bp.hap1.p_ctg.curated.v01.fa
#_______________________________________________________________________________________________________
# run hifiasm01 hap1 curated and manually purged
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/desiree_01.asm.bp.hap1.p_ctg/desiree_01.asm.bp.hap1.p_ctg.curated.v01.manualpurge01.fa
extra_params="--no-contig-ec"
#_______________________________________________________________________________________________________
# run hifiasm01 hap1 curated and manually purged, with additinal orrection (2 purged coontigs were included)
asm=/DKED/scratch/timg/desiree_scaffolding/manual_correction/desiree_01.asm.bp.hap1.p_ctg.curated.v01.manualpurge01.yahs_jbat.review_05_broken_chrOnly_missingAdded.fa
extra_params="--no-contig-ec --no-scaffold-ec"
#_______________________________________________________________________________________________________
# run hifiasm01 hap2 curated and manually purged
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/desiree_01.asm.bp.hap2.p_ctg.curated.v01.manualpurge01/desiree_01.asm.bp.hap2.p_ctg.curated.v01.manualpurge01.fa
extra_params="--no-contig-ec"
#_______________________________________________________________________________________________________
# run hifiasm01 hap2 curated and manually purged with contig error correction
# fisrt rename yahs out dir without contig error correction
mv /DKED/scratch/timg/desiree_scaffolding/yahs/output/desiree_01.asm.bp.hap2.p_ctg.curated.v01.manualpurge01 \
/DKED/scratch/timg/desiree_scaffolding/yahs/output/desiree_01.asm.bp.hap2.p_ctg.curated.v01.manualpurge01_no_contig_ec
# also rename jbat review dir
mv /DKED/scratch/timg/desiree_scaffolding/jbat_review/output/desiree_01.asm.bp.hap2.p_ctg.curated.v01.manualpurge01_no_contig_ec \
/DKED/scratch/timg/desiree_scaffolding/jbat_review/output/desiree_01.asm.bp.hap2.p_ctg.curated.v01.manualpurge01_no_contig_ec_no_contig_ec
asm=/DKED/scratch/timg/desiree_scaffolding/input/assemblies/desiree_01.asm.bp.hap2.p_ctg.curated.v01.manualpurge01/desiree_01.asm.bp.hap2.p_ctg.curated.v01.manualpurge01.fa
extra_params=""
# run hifiasm10 hap3 decontaminated
asm=/scratch/timg/desiree_scaffolding/input/assemblies/10.asm.hap3.p_ctg_decontaminated.fa
extra_params="--no-contig-ec"
#_______________________________________________________________________________________________________
# semi-fixded variables
threads=40
asm_name=$(basename -s .fa $asm)
bam=/scratch/timg/desiree_scaffolding/omni-c_mapping/output/$asm_name/mapped.PT.bam
out_base=/DKED/scratch/timg/desiree_scaffolding/yahs/output
out_dir=$out_base/$asm_name
plots_dir=/DKED/scratch/timg/desiree_scaffolding/input/assemblies

# options to consider
#    --no-contig-ec    do not do contig error correction
#    --no-scaffold-ec  do not do scaffold error correction
#_______________________________________________________________________________________________________
# CODE
# for information about integration with JBAT go to https://github.com/c-zhou/yahs/blob/main/scripts/run_yahs.sh
# prepare output directory
mkdir $out_dir
# run yahs
conda activate yahs
#cd $out_dir
samtools faidx $asm
# yahs
yahs \
-o $out_dir/yahs \
$extra_params \
$asm \
$bam
ln -s $out_dir/yahs_scaffolds_final.fa $plots_dir/$asm_name.yahs.fa

# run juicer pre to convert bin to hic for loading into JBAT
juicer pre -a -o $out_dir/yahs_jbat \
$out_dir/yahs.bin \
$out_dir/yahs_scaffolds_final.agp \
$asm.fai > \
$out_dir/yahs_jbat.log 2>&1
conda deactivate

conda activate java
java -jar -Xmx500G /DKEC/users/timg/juicer_tools_1.22.01.jar pre \
--threads $threads \
$out_dir/yahs_jbat.txt \
$out_dir/yahs_jbat.hic.part <(cat $out_dir/yahs_jbat.log | grep PRE_C_SIZE | awk '{print $2" "$3}')
conda deactivate
mv $out_dir/yahs_jbat.hic.part $out_dir/yahs_jbat.hic
#_______________________________________________________________________________________________________


# ngi orginial command:
(java -jar -Xmx230G /vulpes/proj/ngis/ngi2016004/private/remi/opt/juicer_tools_1.22.01.jar pre out_JBAT.txt out_JBAT.hic.part <(cat out_JBAT.log  | grep PRE_C_SIZE | awk '{print $2" "$3}')) && (mv out_JBAT.hic.part out_JBAT.hic)
# try witgh older version and higher memory, ERROR was out of memory and it looks liek it needs a lot of memory with so many threads
java -jar -Xmx500G /DKEC/users/timg/juicer_tools_1.22.01.jar pre \
--threads $threads \
$out_dir/yahs_jbat.txt \
$out_dir/yahs_jbat.hic.part <(cat $out_dir/yahs_jbat.log | grep PRE_C_SIZE | awk '{print $2" "$3}')
conda deactivate
mv $out_dir/yahs_jbat.hic.part $out_dir/yahs_jbat.hic
This worked, it would probably also work with newer juicer tools version, just needs more ram






















conda activate java
java -jar -Xmx32G /DKEC/users/timg/juicer_tools.2.20.00.jar pre \
/DKED/scratch/timg/desiree_scaffolding/yahs/output/yahs_jbat.txt \
/DKED/scratch/timg/desiree_scaffolding/yahs/output/out_JBAT.hic.part <(cat /DKED/scratch/timg/desiree_scaffolding/yahs/output/ont_only_flye_01_asm_decontaminated_polished.yahs_jbat.log | grep PRE_C_SIZE | awk '{print $2" "$3}')
conda deactivate
mv /DKED/scratch/timg/desiree_scaffolding/yahs/output/out_JBAT.hic.part /DKED/scratch/timg/desiree_scaffolding/yahs/output/out_JBAT.hic




juicer pre -a -o $out_dir/yahs_jbat \
$out_dir.bin \
"$out_dir"_scaffolds_final.agp \
$asm.fai > \
$out_dir.yahs_jbat.log 2>&1