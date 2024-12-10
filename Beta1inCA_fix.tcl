# Load the PDB file
mol new your_protein.pdb

# Set occupancy of all atoms to 0
set all_atoms [atomselect top "all"]
#$all_atoms set occupancy 0.0

# Select CA atoms and set their B-factor (beta) to 1
set ca_atoms [atomselect top "name CA"]
$ca_atoms set beta 1.0

# Select non-CA atoms and set their B-factor (beta) to 0
set non_ca_atoms [atomselect top "not name CA"]
$non_ca_atoms set beta 0.0

# Write the modified PDB file
$all_atoms writepdb modified_protein.pdb

# Close the molecule
mol delete top

