# Get the ID of the loaded molecule
set molID [molinfo top]

# Get the total number of frames in the trajectory
set numFrames [molinfo $molID get numframes]

# Calculate the index of the last frame (frame index starts from 0)
set lastFrame [expr $numFrames - 1]

# Go to the last frame
animate goto $lastFrame

# Write the PDB file for the last frame
set outputPDB "wb_mineq_32.pdb"
animate write pdb $outputPDB

puts "PDB file saved as $outputPDB"
exit
