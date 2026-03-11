
#v8 je v dgenies inputs as of wga referenc.
#kaj je drugo? yahs outputs, tam so vse faste za scaffolde haplotipov

#porti, ki bodo uporabljeni
DGENIES_PORT=6001

#v tem primeru scaffoldi asm16
SCAFFOLD_PORT=6002

#referenca v tem primeru DM v8
REF_PORT=6005


# Zazeni dgenies na poljubnem portu (znotraj novega screena)
screen -R dgenies

#aktiviraj svoj dgenies
conda activate dgenies

DGENIES_PORT=6003
dgenies run --port $DGENIES_PORT --no-browser
#na tej tocki detachas


screen -R scaffold_http
cd /scratch/evakrzisnik/desiree_resequencing/8_yahs/output/
# Zazeni se en http server na novem portu
SCAFFOLD_PORT=6006
python3 -m http.server $SCAFFOLD_PORT
#9. 3. 2026 spremenjen na 6004
#na tej tocki detachas

#obe sekvenci se nahajata v dgenies inputs
screen -R ref_http
cd /scratch/evakrzisnik/desiree_resequencing/7_dgenies/inputs/
# Zazeni se en http server na novem portu
REF_PORT=6007
python3 -m http.server $REF_PORT
#9. 3. 2026 spremenjen na 6004
#na tej tocki detachas



#6000 je zaseden port, do not use
#popravljeno na 6001 je delalo

#!!!!!!!!to zdaj odpres na local powershell
ssh -L 6003:localhost:6003 -L 6006:localhost:6006 -L 6007:localhost:6007 evakrzisnik@egret.nib.si -N

ssh -L 6001:localhost:6001 evakrzisnik@egret.nib.si 

#primerjali bomo vsak haplotip scaffoldov s chronly v8 kot target