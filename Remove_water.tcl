# Load the PSF and PDB files
mol load psf box_col.psf pdb box_col.pdb

# Get the top molecule ID
set mol [molinfo top]

# Define the selection for atoms that are NOT water within 3A of the protein
set keep_atoms [atomselect $mol "not (water and (same residue as within 3 of protein))"]

# Write the new PDB and PSF files, keeping only the selected atoms
$keep_atoms writepdb "box_col_1.pdb"
$keep_atoms writepsf "box_col_1.psf"

# Clean up selections
$keep_atoms delete

# Exit VMD
exit

