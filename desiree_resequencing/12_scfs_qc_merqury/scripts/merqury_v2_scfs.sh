# CHR ONLY
in_base=/scratch/evakrzisnik/desiree_resequencing/12_scfs_qc_merqury/inputs

# ln -s /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs/De_v2.chrOnly.fa \
# $in_base/De_v2_chrOnly.fa

assembly1=$in_base/De_v2_scfs.fa
assembly2=

meryl_db=/scratch/timg/desiree_asm/meryl/desiree_illumina_raw.meryl
out_base=/scratch/evakrzisnik/desiree_resequencing/12_scfs_qc_merqury/outputs
out_name=$(basename "$assembly1" .fa)
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
mkdir -p $out_dir

cd $out_dir

conda activate merqury
    merqury.sh $meryl_db \
        $assembly1 \
        $assembly2 \
        merqury > \
        merqury_$out_name.log

for i in $(basename -s .qv "$out_dir"/*.qv); do
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
