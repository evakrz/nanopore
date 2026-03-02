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

###convenience function!!!
run_quast () {
  local outdir="$1"; shift
  #mkdir -p "$outdir"

  # shellcheck disable=SC2086
  quast \
    $@ \
    -t "$threads" \
    -o "$outdir" \
    --large \
    --eukaryote \
    --k-mer-stats
}

#shranjujem outdir path, ce bo kdaj potrebno spremeniti v mkdir (possibility ponavljanja - chopper problem)


#    12.asm.hap*.p_ctg.fa (all haps from v12 hifiasm)

conda activate quast

threads=40

out_base=/scratch/evakrzisnik/desiree_resequencing/assembly_qc_quast/outputs

haps_12=(
/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap1.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap2.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap3.p_ctg.fa
/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap4.p_ctg.fa
)

run_quast "$out_base/12.asm.p_ctg_haps" "${haps_12[@]}" -l "hap1,hap2,hap3,hap4"

#base_dir=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12
#out_dir=/scratch/evakrzisnik/desiree_resequencing/assembly_qc_quast/outputs/12.asm.p_ctg_haps/

#    10.asm.hap*.p_ctg.fa (all haps from v10 hifiasm)

haps_10=(
/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap1.p_ctg.fa
/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap2.p_ctg.fa
/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap3.p_ctg.fa
/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap4.p_ctg.fa
)

run_quast "$out_base/10.asm.p_ctg_haps" "${haps_10[@]}" -l "hap1,hap2,hap3,hap4"


#base_dir=/scratch/timg/desiree_asm/hifiasm/10
#out_dir=/scratch/evakrzisnik/desiree_resequencing/assembly_qc_quast/outputs/10.asm.p_ctg_haps/

#    12.asm.hap*.p_ctg.fa + 10.asm.hap*.p_ctg.fa (uprabi label (-l): 12_hap1,12_hap2...10_hap4

labels_12_10="12_hap1,12_hap2,12_hap3,12_hap4,10_hap1,10_hap2,10_hap3,10_hap4"
run_quast "$out_base/12_vs_10.asm.p_ctg_haps" \
  "${haps_12[@]}" "${haps_10[@]}" \
  -l "12_hap1,12_hap2,12_hap3,12_hap4,10_hap1,10_hap2,10_hap3,10_hap4"


#base_dir=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12
#out_dir=/scratch/evakrzisnik/desiree_resequencing/assembly_qc_quast/outputs/10.12.asm.p_ctg_all/

#    12.asm.hap_all.p_ctg.fa + 10.asm.hap_all.p_ctg.fa (whole genome 12 vs 10)

all_haps_10=/scratch/timg/desiree_asm/hifiasm/10/10.asm.hap_all.p_ctg.fa

all_haps_12=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12/12.asm.hap_all.p_ctg.fa


run_quast "$out_base/12_vs_10.asm.p_ctg_hap_all" \
  "$all_haps_12" "$all_haps_10" \
  -l "12_hap_all,10_hap_all"


#base_dir=/scratch/evakrzisnik/desiree_resequencing/assembly/outputs/12
#out_dir=/scratch/evakrzisnik/desiree_resequencing/assembly_qc_quast/outputs/10.12.asm.hap_all/

conda deactivate



#Jaz bi naredil 4 verzije primerjav:

#    12.asm.hap*.p_ctg.fa (all haps from v12 hifiasm)
#    10.asm.hap*.p_ctg.fa (all haps from v10 hifiasm)
#    12.asm.hap*.p_ctg.fa + 10.asm.hap*.p_ctg.fa (uprabi label (-l): 12_hap1,12_hap2...10_hap4
#    12.asm.hap_all.p_ctg.fa + 10.asm.hap_all.p_ctg.fa (whole genome 12 vs 10)
