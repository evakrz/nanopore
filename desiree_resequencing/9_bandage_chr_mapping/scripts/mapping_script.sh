#variables
inputs=/scratch/evakrzisnik/desiree_resequencing/9_chromosome_mapping/inputs
outputs=/scratch/evakrzisnik/desiree_resequencing/9_chromosome_mapping/outputs
threads=20

#env test
conda activate minimap
which minimap
conda deactivate

#input je DM current verzija genoma, si jo linkamo v inputs

ln -s /scratch/timg/desiree_scaffolding/input/references/DM_v8.1_chrOnly.fa /scratch/evakrzisnik/desiree_resequencing/9_chromosome_mapping/inputs


#assemblyje, vse .fa, si linkam v inputs
ln -s /scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/16/*.fa /scratch/evakrzisnik/desiree_resequencing/9_chromosome_mapping/inputs


conda activate minimap
#minimap2 -ax asm5 ref.fa asm.fa > aln.sam       # assembly to assembly/ref alignment
#the -ax flag outputs a .sam file, a -x flag is a .paf file

minimap2 -t $threads -x asm5 $inputs/DM_v8.1_chrOnly.fa $inputs/desiree_16.asm.hic.p_utg.fa > $outputs/16.p.utg_dm_8.1.paf

conda deactivate
