#porti, ki bodo uporabljeni
DGENIES_PORT=6001
ASSEMBLY_PORT=6002
REF_PORT=6003



# aktiviraj moj conda env
conda activate /users/timg/.conda/envs/dgenies
# Zazeni dgenies na poljubnem portu (znotraj novega screena)
dgenies run --port $DGENIES_PORT --no-browser

# cd v direktorij s fastami, npr:
cd /scratch/evakrzisnik/desiree_resequencing/assembly/outputs 
# Zazeni preprost http file ferver, da bodo faste dostopne preko networka
python3 -m http.server $ASSEMBLY_PORT

# Najbolje, da naredim dir v dgenies inputs, kjer bodo te linki?
# Enako naredi se za fasto, ki jo bos primerjala, morda najlazje, da najprej linkas trenutni genom nekam k sebi
ln -s /data-repository/genomes/plant_stu/StDesiree_v1/whole_genome/De_v1*fa.gz
ln -s /data-repository/genomes/plant_stu/StDesiree_v1/individual_haplotypes/hap_*/De_v1_hap*.fa.gz

cd <path/to/linked/De_v1_genome>
# Zazeni se en http server na novem portu
python3 -m http.server $REF_PORT

#6000 je zaseden port, do not use
#popravljeno na 6001 je delalo
#to odpres na local powershell
ssh -L 6000:localhost:6000 -L 6001:localhost:6001 -L 6002:localhost:6002 evakrzisnik@egret.nib.si -N
ssh -L 6000:localhost:6000 evakrzisnik@egret.nib.si 


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