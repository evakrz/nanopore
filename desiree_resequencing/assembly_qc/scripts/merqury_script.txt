
# run 1 07 hifiasm decontaminated
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/desiree_07.asm.hic.hap1.p_ctg_decontaminated.fa
assembly2=/scratch/timg/desiree_scaffolding/input/assemblies/desiree_07.asm.hic.hap2.p_ctg_decontaminated.fa
out_name=hifiasm_07_decontaminated
#_____________________________________________________________________________________________________________________
# run 2 07 hifiasm decontaminated purged
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/desiree_07.asm.hic.hap1.p_ctg_decontaminated_purged/purged_ends_modified_desiree_07.asm.hic.hap1.p_ctg_decontaminated.fa
assembly2=/scratch/timg/desiree_scaffolding/input/assemblies/desiree_07.asm.hic.hap2.p_ctg_decontaminated_purged/purged_ends_modified_desiree_07.asm.hic.hap2.p_ctg_decontaminated.fa
out_name=hifiasm_07_decontaminated_purged
#_____________________________________________________________________________________________________________________
# run 3 06 hifiasm purged default yahs jbat review v1.3b
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/yahs_v1.3b.fa
assembly2=""
out_name=yahs_v1.3b
#_____________________________________________________________________________________________________________________
# run 4 06 hifiasm purged default yahs jbat review v1.3b chromosomes only
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/yahs_v1.3b_chrOnly.fa
assembly2=""
out_name=yahs_v1.3b_chrOnly
#_____________________________________________________________________________________________________________________
# run 6 01 hifiasm purged with purge_haplotigs
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/desiree_01.asm.bp.hap1.p_ctg/desiree_01.asm.bp.hap1.p_ctg.curated.v01.fa
assembly2=""
out_name=hifiasm01_purged
#_____________________________________________________________________________________________________________________
# run 7 01 hifiasm r_utg
assembly1=/scratch/timg/desiree_asm/hifiasm/01/desiree_01.asm.bp.r_utg.fa
assembly2=""
out_name=hifiasm01_r_utg
#_____________________________________________________________________________________________________________________
# run 8 01 hifiasm p_utg
assembly1=/scratch/timg/desiree_asm/hifiasm/01/desiree_01.asm.bp.p_utg.fa
assembly2=""
out_name=hifiasm01_p_utg
#_____________________________________________________________________________________________________________________
# run 9 01 hifiasm p_ctg
assembly1=/scratch/timg/desiree_asm/hifiasm/01/desiree_01.asm.bp.p_ctg.fa
assembly2=""
out_name=hifiasm01_p_ctg
#_____________________________________________________________________________________________________________________
# fix old runs scales
out_name=desiree_06.asm.p_ctg
out_name=hifiasm_06_p_ctg_purged_all
out_name=hifiasm_06_p_ctg_purged_ends_only
#_____________________________________________________________________________________________________________________
# run 10 02 hifiasm r_utg
assembly1=/scratch/timg/desiree_asm/hifiasm/02/desiree_02.asm.r_utg.fa
assembly2=""
out_name=hifiasm02_r_utg
#_____________________________________________________________________________________________________________________
# run 11 02 hifiasm p_utg
assembly1=/scratch/timg/desiree_asm/hifiasm/02/desiree_02.asm.p_utg.fa
assembly2=""
out_name=hifiasm02_p_utg
#_____________________________________________________________________________________________________________________
# run 12 02 hifiasm p_ctg
assembly1=/scratch/timg/desiree_asm/hifiasm/02/desiree_02.asm.p_ctg.fa
assembly2=""
out_name=hifiasm02_p_ctg
#_____________________________________________________________________________________________________________________
# run 13 02 hifiasm p_ctg and a_ctg
assembly1=/scratch/timg/desiree_asm/hifiasm/02/desiree_02.asm.p_ctg.fa
assembly2=/scratch/timg/desiree_asm/hifiasm/02/desiree_02.asm.a_ctg.fa
out_name=hifiasm02_p-a_ctg
#_____________________________________________________________________________________________________________________
# run 14 09 hifiasm p_ctg all haplotypes combined
assembly1=/scratch/timg/desiree_asm/hifiasm/09/desiree_09.asm.hic.hap_all.p_ctg.fa
assembly2=
out_name=hifiasm_09_p_ctg_hap_all
#_____________________________________________________________________________________________________________________
# run 15 09 hifiasm p_ctg HAP 1
assembly1=/scratch/timg/desiree_asm/hifiasm/09/desiree_09.asm.hic.hap1.p_ctg.fa
assembly2=
out_name=hifiasm_09_p_ctg_hap_1
#_____________________________________________________________________________________________________________________
# run 16 09 hifiasm p_ctg HAP 2
assembly1=/scratch/timg/desiree_asm/hifiasm/09/desiree_09.asm.hic.hap2.p_ctg.fa
assembly2=
out_name=hifiasm_09_p_ctg_hap_2
#_____________________________________________________________________________________________________________________
# run 17 09 hifiasm p_ctg HAP 3
assembly1=/scratch/timg/desiree_asm/hifiasm/09/desiree_09.asm.hic.hap3.p_ctg.fa
assembly2=
out_name=hifiasm_09_p_ctg_hap_3
#_____________________________________________________________________________________________________________________
# run 18 09 hifiasm p_ctg HAP 4
assembly1=/scratch/timg/desiree_asm/hifiasm/09/desiree_09.asm.hic.hap4.p_ctg.fa
assembly2=
out_name=hifiasm_09_p_ctg_hap_4
#_____________________________________________________________________________________________________________________
# run 19 09 hifiasm p_ctg
assembly1=/scratch/timg/desiree_asm/hifiasm/09/desiree_09.asm.hic.p_ctg.fa
assembly2=
out_name=hifiasm_09_p_ctg
#_____________________________________________________________________________________________________________________
# run 20 09 hifiasm p_ctg HAP 1 purged
assembly1=/scratch/timg/desiree_asm/purge_dups/desiree_09.asm.hic.hap1.p_ctg/purged_ends_modified.fa
assembly2=
out_name=hifiasm_09_p_ctg_purged
#_____________________________________________________________________________________________________________________
# run 21 09 hifiasm p_utg
assembly1=/scratch/timg/desiree_asm/hifiasm/09/desiree_09.asm.hic.p_utg.fa
assembly2=
out_name=hifiasm_09_p_utg
#_____________________________________________________________________________________________________________________
# run 22 10 hifiasm p_utg
assembly1=/scratch/timg/desiree_asm/hifiasm/09/desiree_10.asm.hic.p_utg.fa
assembly2=
out_name=hifiasm_10_p_utg
#_____________________________________________________________________________________________________________________
# run 23 10 hifiasm p_ctg all haplotypes combined
assembly1=/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap_all.p_ctg.fa
assembly2=
out_name=10_p_ctg_hap_all
#_____________________________________________________________________________________________________________________
# run 24 10 hifiasm p_ctg HAP1
assembly1=/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap1.p_ctg.fa
assembly2=
out_name=10_p_ctg_hap1
#_____________________________________________________________________________________________________________________
# run 25 10 hifiasm p_ctg HAP2
assembly1=/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap2.p_ctg.fa
assembly2=
out_name=10_p_ctg_hap1
#_____________________________________________________________________________________________________________________
# run 26 10 hifiasm p_ctg HAP3
assembly1=/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap3.p_ctg.fa
assembly2=
out_name=10_p_ctg_hap3
#_____________________________________________________________________________________________________________________
# run 27 10 hifiasm p_ctg HAP4
assembly1=/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap4.p_ctg.fa
assembly2=
out_name=10_p_ctg_hap4
#_____________________________________________________________________________________________________________________
# run 27 10 hifiasm p_ctg HAP4
assembly1=/scratch/timg/desiree_asm/hifiasm/11/desiree_11.asm.hic.p_ctg.fa
assembly2=
out_name=11_p_ctg
#_____________________________________________________________________________________________________________________
# run 28 10 hifiasm 10 hap3 decontaminated yahs review 02 ChrOnly
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/10.asm.hap3.p_ctg_decontaminated/10.asm.hap3.p_ctg_decontaminated.yahs_jbat.review_02_chrOnly.fa
assembly2=
out_name=10_asm_hap3_decont_review_02_chrOnly
#_____________________________________________________________________________________________________________________
# run 29 10 hifiasm 10 hap3 decontaminated 
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/10.asm.hap3.p_ctg_decontaminated/10.asm.hap3.p_ctg_decontaminated.fa
assembly2=
out_name=10_asm_hap3_decont
#_____________________________________________________________________________________________________________________
# run 30 10 hifiasm 10 hap3 decontaminated 
assembly1/scratch/timg/desiree_scaffolding/input/assemblies/De_v1_hap3/De_v1_hap3_chrs_dups.fa
assembly2=
out_name=De_v1_hap3_chrs_dups
#_____________________________________________________________________________________________________________________
# run 31 10 hifiasm 10 hap3 decontaminated 
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/De_v1_hap3/De_v1_hap3_chrs_small.fa
assembly2=
out_name=De_v1_hap3_chrs_small
#_____________________________________________________________________________________________________________________
# run 32 10 hifiasm 10 hap3 decontaminated 
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/De_v1_hap3/De_v1_hap3_chrs.fa
assembly2=
out_name=De_v1_hap3_chrs
#_____________________________________________________________________________________________________________________
# run 33 10 hifiasm 10 hap2 decontaminated 
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/De_v1_hap2/De_v1_hap2_chrs.fa
assembly2=
out_name=De_v1_hap2_chrs
#_____________________________________________________________________________________________________________________
# run 33 10 hifiasm 10 hap2 and hap3
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/De_v1_hap2/De_v1_hap2_chrs.fa
assembly2=/scratch/timg/desiree_scaffolding/input/assemblies/De_v1_hap3/De_v1_hap3_chrs.fa
out_name=De_v1_hap2_hap3_chrs
#_____________________________________________________________________________________________________________________
# run 34 De_v1_chrs
assembly1=/scratch/timg/desiree_annotation/jbrowse_data/fastas/De_v1_chrs.fa
assembly2=
out_name=De_v1_chrs
#_____________________________________________________________________________________________________________________
# run 35 De_v1
assembly1=/scratch/timg/desiree_annotation/jbrowse_data/fastas/De_v1_asm.fa
assembly2=
out_name=De_v1_asm
#_____________________________________________________________________________________________________________________
# run 36 De_v1_hap1_chrs
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/De_v1_hap1/De_v1_hap1_chrs.fa
assembly2=
out_name=De_v1_hap1_chrs
#_____________________________________________________________________________________________________________________
# run 37 De_v1_hap4_chrs
assembly1=/scratch/timg/desiree_scaffolding/input/assemblies/De_v1_hap4/De_v1_hap4_chrs.fa
assembly2=
out_name=De_v1_hap4_chrs
#_____________________________________________________________________________________________________________________
#run 38 12 hifiasm p_ctg ALL HAPLOTYPES
assembly1=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap_all.p_ctg.fa
assembly2=
out_name=12_p_ctg_hap_all
#_____________________________________________________________________________________________________________________
# run 39 12 hifiasm p_ctg HAP1
assembly1=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap1.p_ctg.fa
assembly2=
out_name=12_p_ctg_hap1
#_____________________________________________________________________________________________________________________
# run 40 12 hifiasm p_ctg HAP2
assembly1=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap2.p_ctg.fa
assembly2=
out_name=12_p_ctg_hap2
#_____________________________________________________________________________________________________________________
# run 41 12 hifiasm p_ctg HAP3
assembly1=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap3.p_ctg.fa
assembly2=
out_name=12_p_ctg_hap3
#_____________________________________________________________________________________________________________________
# run 42 12 hifiasm p_ctg HAP4
assembly1=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap4.p_ctg.fa
assembly2=
out_name=12_p_ctg_hap4


# semi-fixed variables
meryl_db=/scratch/timg/desiree_asm/meryl/desiree_illumina_raw.meryl
out_base=/scratch/evakrzisnik/desiree_resequencing/assembly_qc/outputs
out_dir=$out_base/$out_name
maxcov=200
maxcount=15000000
threads=8
#_____________________________________________________________________________________________________________________
### CODE
#set threads
OMP_NUM_THREADS=$threads
export OMP_NUM_THREADS
# comparing two assemblies
mkdir $out_dir
# merqury does not recognize path as output dir so you have to cd inside
cd $out_dir
conda activate merqury
merqury.sh $meryl_db \
    $assembly1 \
    $assembly2 \
    merqury > \
    merqury_$out_name.log

for i in $(basename -s .qv "$out_dir"/*.qv)
 do
  Rscript /users/evakrzisnik/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
  -f "$i".spectra-cn.hist \
  -o "$i".spectra-cn \
  -z "$i".only.hist \
  -m $maxcov \
  -n $maxcount
 done

Rscript /users/evakrzisnik/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
    -f merqury.spectra-asm.hist \
    -o merqury.spectra-asm \
    -z merqury.dist_only.hist \
    -m $maxcov \
    -n $maxcount
conda deactivate
#_____________________________________________________________________________________________________________________
#moje do tle

###### LOOP VERSION

for file in /scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12
do
assembly1=$file
assembly2=""
out_name=$(basename "$file" .fa | sed "s/\./_/g")
echo "Starting file: $file with name $out_name"

# semi-fixed variables
meryl_db=/scratch/timg/desiree_asm/meryl/desiree_illumina_raw.meryl
out_base=/scratch/evakrzisnik/desiree_resequencing/assembly_qc/outputs
out_dir=$out_base/$out_name
maxcov=200
maxcount=15000000
threads=20
#_____________________________________________________________________________________________________________________
### CODE
#set threads
OMP_NUM_THREADS=$threads
export OMP_NUM_THREADS
# comparing two assemblies
mkdir $out_dir
# merqury does not recognize path as output dir so you have to cd inside
cd $out_dir
conda activate merqury
merqury.sh $meryl_db \
    $assembly1 \
    $assembly2 \
    merqury > \
    merqury_$out_name.log

for i in $(basename -s .qv "$out_dir"/*.qv)
 do
  Rscript /users/timg/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
  -f "$i".spectra-cn.hist \
  -o "$i".spectra-cn \
  -z "$i".only.hist \
  -m $maxcov \
  -n $maxcount
 done

Rscript /users/timg/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
    -f merqury.spectra-asm.hist \
    -o merqury.spectra-asm \
    -z merqury.dist_only.hist \
    -m $maxcov \
    -n $maxcount
conda deactivate
done
#_____________________________________________________________________________________________________________________
















# fixing plot scales in old runs
cd $out_dir

for i in $(basename -s .qv "$out_dir"/*.qv)
 do
  Rscript /users/timg/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
  -f "$i".spectra-cn.hist \
  -o "$i".spectra-cn \
  -z "$i".only.hist \
  -m $maxcov \
  -n $maxcount
 done

Rscript /users/timg/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
-f $out_name.spectra-asm.hist \
-o $out_name.spectra-asm \
-z $out_name.dist_only.hist \
-m $maxcov \
-n $maxcount



#################### ARCHIVE ########################
#################### merqury for purged and haplotigs

cd /DKHC/scratch/timg/desiree_asm/merqury/

merqury.sh /DKHC/scratch/timg/desiree_asm/meryl/desiree_illumina_raw.meryl \
    /DKHC/scratch/timg/desiree_asm/purge_dups/desiree_06.asm.p_ctg/purged_all.fa \
    /DKHC/scratch/timg/desiree_asm/purge_dups/desiree_06.asm.p_ctg/hap_all.fa \
    hifiasm_06_p_ctg_purged_all > \
    merqury_hifiasm_06_p_ctg_purged_all.log

merqury.sh /DKHC/scratch/timg/desiree_asm/meryl/desiree_illumina_raw.meryl \
    /DKHC/scratch/timg/desiree_asm/purge_dups/desiree_06.asm.p_ctg/purged_ends_only.fa \
    /DKHC/scratch/timg/desiree_asm/purge_dups/desiree_06.asm.p_ctg/hap_ends_only.fa \
    hifiasm_06_p_ctg_purged_ends_only > \
    merqury_hifiasm_06_p_ctg_purged_ends_only.log


cd /DKHC/scratch/timg/desiree_asm/merqury/desiree_06.asm.p_ctg_purged_all/

for i in $(find *.spectra-cn.hist | sed 's/spectra-cn.hist//g')
 do
  Rscript /users/timg/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
  -f "$i"spectra-cn.hist \
  -o "$i"spectra-cn \
  -z "$i"only.hist \
  -m 140 \
  -n 15000000
 done

Rscript /users/timg/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
-f hifiasm_06_p_ctg_purged_all.spectra-asm.hist \
-o hifiasm_06_p_ctg_purged_all.spectra-asm \
-z hifiasm_06_p_ctg_purged_all.dist_only.hist \
-m 140 \
-n 15000000
 
cd /DKHC/scratch/timg/desiree_asm/merqury/desiree_06.asm.p_ctg_purged_ends_only/

for i in $(find *.spectra-cn.hist | sed 's/spectra-cn.hist//g')
 do
  Rscript /users/timg/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
  -f "$i"spectra-cn.hist \
  -o "$i"spectra-cn \
  -z "$i"only.hist \
  -m 140 \
  -n 15000000
 done

Rscript /users/timg/.conda/envs/merqury/share/merqury/plot/plot_spectra_cn.R \
-f hifiasm_06_p_ctg_purged_ends_only.spectra-asm.hist \
-o hifiasm_06_p_ctg_purged_ends_only.spectra-asm \
-z hifiasm_06_p_ctg_purged_ends_only.dist_only.hist \
-m 140 \
-n 15000000
