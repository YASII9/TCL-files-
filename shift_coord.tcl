set mol [mol new wat_tip4p2005_45.pdb]
set sel [atomselect $mol all]


# Define the shift vector
set shift_vector {0 0 45}  ;# Replace with your shift values

# Shift coordinates
$sel moveby $shift_vector

# Write the shifted PDB
$sel writepdb watshift45.pdb

exit
