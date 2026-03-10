
screen -R dgenies

#porti, ki bodo uporabljeni
DGENIES_PORT=6001
ASSEMBLY_PORT=6002
REF_PORT=6003

# aktiviraj moj conda env - permission denied
#conda activate /users/timg/.conda/envs/dgenies

#ni hotel klonirati, issues z permissioni
#conda create -n dgenies --clone /users/timg/.conda/envs/dgenies



#frfr naredimo conda env
conda create -n dgenies -c bioconda -c conda-forge dgenies

#aktiviraj svoj dgenies
conda activate dgenies
# Zazeni dgenies na poljubnem portu (znotraj novega screena)

screen -R dgenies
dgenies run --port $DGENIES_PORT --no-browser
#na tej tocki detachas

screen -R assembly_http
# cd v direktorij s fastami, npr:
cd /scratch/evakrzisnik/desiree_resequencing/3_assembly/outputs 
# Zazeni preprost http file ferver, da bodo faste dostopne preko networka
python3 -m http.server $ASSEMBLY_PORT
#na tej tocki detachas

# Enako naredi se za fasto, ki jo bos primerjala, morda najlazje, da najprej linkas trenutni genom nekam k sebi

# ln -s /data-repository/genomes/plant_stu/StDesiree_v1/whole_genome/De_v1*fa.gz
# ln -s /data-repository/genomes/plant_stu/StDesiree_v1/individual_haplotypes/hap_*/De_v1_hap*.fa.gz

ln -s /data-repository/genomes/plant_stu/StDesiree_v1/whole_genome/De_v1*.fa.gz /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/
ln -s /data-repository/genomes/plant_stu/StDesiree_v1/individual_haplotypes/hap_*/De_v1_hap*.fa.gz /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/

screen -R ref_http
cd /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/
# Zazeni se en http server na novem portu
python3 -m http.server $REF_PORT
#9. 3. 2026 spremenjen na 6004
#na tej tocki detachas


#6000 je zaseden port, do not use
#popravljeno na 6001 je delalo

#!!!!!!!!to zdaj odpres na local powershell
ssh -L 6000:localhost:6000 -L 6001:localhost:6001 -L 6002:localhost:6002 evakrzisnik@egret.nib.si -N
ssh -L 6000:localhost:6000 evakrzisnik@egret.nib.si 

#9. 3. 2026 zadnji spremenjen iz refport na 6004
ssh -L 6001:localhost:6001 -L 6002:localhost:6002 -L 6004:localhost:6004 evakrzisnik@egret.nib.si -N
ssh -L 6001:localhost:6001 evakrzisnik@egret.nib.si 


echo "On your LOCAL machine, run:"
echo
echo "  ssh -L $DGENIES_PORT:localhost:$DGENIES_PORT \\"
echo "      -L $ASSEMBLY_PORT:localhost:$ASSEMBLY_PORT \\"
echo "      -L $REF_PORT:localhost:$REF_PORT \\"
echo "      evakrzisnik@egret.nib.si"
echo
echo "Then open in your browser:"
echo "  D-GENIES:           http://localhost:$DGENIES_PORT"
echo "  Assembly FASTAs:    http://localhost:$ASSEMBLY_PORT"
echo "  Reference FASTAs:   http://localhost:$REF_PORT"

#ko zaganjas dgenies, je target kromosomi iz genoma,
#query pa je assembly, torej kontigi v haplotipu

#pozenes za vsak query, torej za 4 haplotipe
#target za vsak query je de_v1 haplotipi posamicno
#in de_v1 chrs