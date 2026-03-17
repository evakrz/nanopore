# agp_to_fasta
# Usage: agp_to_fasta [options] <scaffolds.agp> <contigs.fa>
# Options:
#     -l INT            line width [60]
#     -u                include sequence components with unknown orientations
#     -o STR            output to file [stdout]
#     --version         show version number


#the inputs folder must include the edited .agp file 
#the file name MUST SPECIFY: haplotype, review id, some flag to denote modified or manual or whatever
#the same is true for the out file: ALL CHANGES MUST BE TRACEABLE

#first step: create a copy of the files that will be changed
#DO NOT LINK THE AGP FILES, INSTEAD COPY THEM
#these contain the same information 
#our yahs modification will output a new fasta file, using the modified version of these files
cp /scratch/evakrzisnik/desiree_resequencing/10_scaf_review/output/hap1/yahs_jbat.review3.FINAL.agp \
 /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs/hap1.review3.agp

 cp /scratch/evakrzisnik/desiree_resequencing/10_scaf_review/output/hap2/yahs_jbat.review4.FINAL.agp \
 /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs/hap2.review4.agp

 cp /scratch/evakrzisnik/desiree_resequencing/10_scaf_review/output/hap3/yahs_jbat.review5.FINAL.agp \
 /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs/hap3.review5.agp

 cp /scratch/evakrzisnik/desiree_resequencing/10_scaf_review/output/hap4/yahs_jbat.review4.FINAL.agp \
 /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs/hap4.review4.agp

#so after working with them, you will have: some scaffolds removed from them and some added
#make new empty files with the same name, just the suffix modified.agp
#and this will actually be the input for yahs

#this is to test formatting after copying and pasting from excel into notepad
#we should get only 9 as output - that means the agp file contains 9 columns
awk '{print NF}' /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs/hap1.review3.modified.agp | sort -u
awk '{print NF}' /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs/hap2.review4.modified.agp | sort -u
awk '{print NF}' /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs/hap3.review5.modified.agp | sort -u
awk '{print NF}' /scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs/hap4.review4.modified.agp | sort -u


conda activate yahs

in_base=/scratch/evakrzisnik/desiree_resequencing/11_agp_editing/inputs
out_base=/scratch/evakrzisnik/desiree_resequencing/11_agp_editing/outputs


for file in "$in_base"/*.modified.agp; do

    base=$(basename "$file" .agp)

    scaffolds="$file"

    #original hifiasm contigs - same in all cases, this is where it will retrieve the non-haplotype scaffolds
    contigs=/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/16/16.asm.hap_all.p_ctg.fa

    agp_to_fasta -o "$out_base/$base.fa" "$scaffolds" "$contigs"

done

conda deactivate


# #agp file location
# for file in $in_base/modified.agp
# do

# scaffolds=$in_base/$file

# #original hifiasm contigs - same in all cases, this is where it will retrieve the non-haplotype scaffolds
# contigs=/scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs/16/16.asm.hap_all.p_ctg.fa

# agp_to_fasta -o $out_base/$file.fa $scaffolds $contigs

# done
