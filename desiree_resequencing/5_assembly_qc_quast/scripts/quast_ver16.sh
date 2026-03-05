#Gledam malo stare reporte in bi morda res bilo dobro zalaufat quast: https://quast.sourceforge.net/docs/manual.html
#Ima dobre vizualne reporte, malo bolj intuitivne in ve� statistik.
#Poglej kaj so outputi in kako uporabljat. Ima en kup opcij.

#Tole je en primer iz moje skripte:

########


#threads=40

#base_dir=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12
#out_dir=/scratch/timg/desiree_asm/quast/09.asm.p_ctg_all

#conda activate quast
#quast \
 #$base_dir/09.asm.hap1.p_ctg.fa \
 #$base_dir/09.asm.hap2.p_ctg.fa \
 #$base_dir/09.asm.hap3.p_ctg.fa \
 #$base_dir/09.asm.hap4.p_ctg.fa \
 #-t $threads \
 #-o $out_dir \
 #--large \
 #--eukaryote \
 #--k-mer-stats \
 #-l hap1,hap2,hap3,hap4
#conda deactivate

########
###eva 

###convenience function, run at the beginning and these parameters will be set every time
run_quast () {
  local outdir="$1"; shift
  mkdir -p "$outdir"

  quast \
    "$@" \
    -t "$threads" \
    -o "$outdir" \
    --large \
    --eukaryote \
    --k-mer-stats
}



#    12.asm.hap*.p_ctg.fa (all haps from v12 hifiasm)

conda activate quast

threads=40


#primerjamo 16, ki je mar 2026 assembly s tremi ONT knjiznicami in HiFi
asm_a=16

# #timov star assembly brez vseh ONT odcitkov
# asm_b=10

#moj assembly brez lib 3
asm_b=15

out_base=/scratch/evakrzisnik/desiree_resequencing/5_assembly_qc_quast/outputs

haps_a=(
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_a/$asm_a.asm.hap1.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_a/$asm_a.asm.hap2.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_a/$asm_a.asm.hap3.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_a/$asm_a.asm.hap4.p_ctg.fa
)

# #ko je haps_b bil timov assembly
# haps_b=(
# /scratch/timg/desiree_asm/hifiasm/$asm_b/$asm_b.asm.hap1.p_ctg.fa
# /scratch/timg/desiree_asm/hifiasm/$asm_b/$asm_b.asm.hap2.p_ctg.fa
# /scratch/timg/desiree_asm/hifiasm/$asm_b/$asm_b.asm.hap3.p_ctg.fa
# /scratch/timg/desiree_asm/hifiasm/$asm_b/$asm_b.asm.hap4.p_ctg.fa
# )

#ko je haps_b moj prejsnji assembly 15 brez nove ONT lib3, samo old in lib2
haps_b=(
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_b/$asm_b.asm.hap1.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_b/$asm_b.asm.hap2.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_b/$asm_b.asm.hap3.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_b/$asm_b.asm.hap4.p_ctg.fa
)

# run_quast "$out_base/16.asm.p_ctg_haps" "${haps_16[@]}" \
#  -l "hap1,hap2,hap3,hap4"

# #analiza samo asm_a

# run_quast "$out_base/${asm_a}.asm.p_ctg_haps" \
#   "${haps_a[@]}" \
#   -l "${asm_a}_hap1,${asm_a}_hap2,${asm_a}_hap3,${asm_a}_hap4"



labels="${asm_a}_hap1,${asm_a}_hap2,${asm_a}_hap3,${asm_a}_hap4,${asm_b}_hap1,${asm_b}_hap2,${asm_b}_hap3,${asm_b}_hap4"

#primerjava asm_a in asm_b posamezni haplotipi

run_quast "$out_base/${asm_a}_vs_${asm_b}.asm.p_ctg_haps" \
  "${haps_a[@]}" "${haps_b[@]}" \
  -l "$labels"



#primerjava skupaj zdruzenih haplotipov asm_a in asm_b

all_haps_a=/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_a/$asm_a.asm.hap_all.p_ctg.fa


# #ko so zdruzeni haplotipi bili timov star assembly
# all_haps_b=/scratch/timg/desiree_asm/hifiasm/$asm_b/$asm_b.asm.hap_all.p_ctg.fa

#ko so zdruzeni haplotipi bili moj ver15 brez lib3
all_haps_b=/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/$asm_b/$asm_b.asm.hap_all.p_ctg.fa


run_quast "$out_base/${asm_a}_vs_${asm_b}.asm.p_ctg_hap_all" \
  "$all_haps_a" "$all_haps_b" \
  -l "${asm_a}_hap_all,${asm_b}_hap_all"


conda deactivate 

# run_quast "$out_base/10.asm.p_ctg_haps" "${haps_10[@]}" -l "hap1,hap2,hap3,hap4"


#    12.asm.hap*.p_ctg.fa + 10.asm.hap*.p_ctg.fa (uprabi label (-l): 12_hap1,12_hap2...10_hap4

# labels_12_10="12_hap1,12_hap2,12_hap3,12_hap4,10_hap1,10_hap2,10_hap3,10_hap4"
# run_quast "$out_base/12_vs_10.asm.p_ctg_haps" \
#   "${haps_12[@]}" "${haps_10[@]}" \
#   -l "12_hap1,12_hap2,12_hap3,12_hap4,10_hap1,10_hap2,10_hap3,10_hap4"


#base_dir=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12
#out_dir=/scratch/evakrzisnik/desiree_resequencing/assembly_qc_quast/outputs/10.12.asm.p_ctg_all/

#    12.asm.hap_all.p_ctg.fa + 10.asm.hap_all.p_ctg.fa (whole genome 12 vs 10)

# all_haps_10=/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap_all.p_ctg.fa

# all_haps_12=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap_all.p_ctg.fa


# run_quast "$out_base/12_vs_10.asm.p_ctg_hap_all" \
#   "$all_haps_12" "$all_haps_10" \
#   -l "12_hap_all,10_hap_all"


#base_dir=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12
#out_dir=/scratch/evakrzisnik/desiree_resequencing/assembly_qc_quast/outputs/10.12.asm.hap_all/


###########################





#Jaz bi naredil 4 verzije primerjav:

#    12.asm.hap*.p_ctg.fa (all haps from v12 hifiasm)
#    10.asm.hap*.p_ctg.fa (all haps from v10 hifiasm)
#    12.asm.hap*.p_ctg.fa + 10.asm.hap*.p_ctg.fa (uprabi label (-l): 12_hap1,12_hap2...10_hap4
#    12.asm.hap_all.p_ctg.fa + 10.asm.hap_all.p_ctg.fa (whole genome 12 vs 10)
