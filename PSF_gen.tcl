package require psfgen
topology TIP4P_2005.top
segment U {pdb tip4p2005.pdb}
coordpdb tip4p2005.pdb U
guesscoord
writepsf tip4p2005_new1.psf
writepdb tip4p2005_new1.pdb
exit

