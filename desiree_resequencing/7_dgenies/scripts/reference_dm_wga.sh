

#najprej moramo DM v6 spravit tudi na chrOnly s seqkitom, kaj to pomeni?
conda activate seqkit

path_to_v6=/scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/DM_v6.fa
seqkit fx2tab -nl $path_to_v6 | sort -k2,2nr | head -30

seqkit grep -r -p "^chr" $path_to_v6 > /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/DM_v6.1_chrOnly.fa
seqkit stats /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/DM_v6.1_chrOnly.fa

conda deactivate

ln -s /scratch/timg/desiree_scaffolding/input/references/DM_v8.1_chrOnly.fa /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs


#porti, ki bodo uporabljeni
DGENIES_PORT=6001

#assembly v tem primeru DM v8
ASSEMBLY_PORT=6002

#referenca v tem primeru DM v6
REF_PORT=6005


# Zazeni dgenies na poljubnem portu (znotraj novega screena)
screen -R dgenies

#aktiviraj svoj dgenies
conda activate dgenies

DGENIES_PORT=6001
dgenies run --port $DGENIES_PORT --no-browser
#na tej tocki detachas


#obe sekvenci se nahajata v dgenies inputs
screen -R seq_http
cd /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/
# Zazeni se en http server na novem portu
REF_PORT=6005
python3 -m http.server $REF_PORT
#9. 3. 2026 spremenjen na 6004
#na tej tocki detachas


#6000 je zaseden port, do not use
#popravljeno na 6001 je delalo

#!!!!!!!!to zdaj odpres na local powershell
ssh -L 6001:localhost:6001 -L 6005:localhost:6005 evakrzisnik@egret.nib.si -N

ssh -L 6001:localhost:6001 evakrzisnik@egret.nib.si 

#rezultat: smo ugotovili, da se kromosom 12 obrne pri prehodu iz v6 na v8. zdajsnja verzija desireja na nibu je
#poravnana na v8, zato bom tako naredila tudi jaz