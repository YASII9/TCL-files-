# Load the structure file (.psf or .pdb)
mol new wat_tip4p2005_45.psf type psf

# Load only the last frame of the .dcd file
mol addfile wat_min45.dcd type dcd first -1 last -1 step 1 waitfor all

# Select all atoms in the last frame
set all_atoms [atomselect top "all"]

# Write the selected atoms to a .pdb file
$all_atoms writepdb wat_min45_last1.pdb

# Delete the atom selection to free memory
$all_atoms delete

# Exit VMD
exit

