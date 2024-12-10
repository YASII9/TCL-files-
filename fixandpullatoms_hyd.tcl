# Load the original PDB file
mol new Hcol.pdb

# Set beta to 1 for fixed atoms and occupancy to 0.8 for pulled atoms
set fixed_atoms {45224 45596 45968}
set pull_atoms {45557 45929 46301}

foreach atom_id $fixed_atoms {
    set sel [atomselect top "index $atom_id"]
    $sel set beta 1
    $sel delete
}

foreach atom_id $pull_atoms {
    set sel [atomselect top "index $atom_id"]
    $sel set occupancy 0.8
    $sel delete,
}

# Write the modified structure to a new PDB file
set all [atomselect top "all"]
$all writepdb updated.pdb
$all delete

# Exit VMD
exit

