proc lab_coords {} {
    # Load the molecular structure and trajectory files
    set mol [mol new "collagen.psf" type psf waitfor all]
    mol addfile "collagen_modified_ocu.dcd" type dcd first 0 last -1 molid $mol waitfor all
    
    # Get the number of frames in the trajectory
    set nf [molinfo $mol get numframes]
    
    # Open the output file for writing
    set output [open CA_pull_cordnates.dat w]
    
    # Loop over each frame in the trajectory
    for {set frm 0} {$frm < $nf} {incr frm} {
        # Select the first CA atom of a GLY residue in the current frame
        set first_ca [atomselect $mol "name CA and resname GLY" frame $frm]
        set first_ca_coords [lindex [$first_ca get {x y z}] 0]
        
        # Select the last CA atom of a GLY residue in the current frame
        set num_gly [$first_ca num]
        set last_ca_coords [lindex [$first_ca get {x y z}] [expr {$num_gly - 1}]]
        
        # Write the coordinates to the output file
        puts $output "frame $frm: first CA coordinates: $first_ca_coords, last CA coordinates: $last_ca_coords"
        
        # Delete the atom selection to free up memory
        $first_ca delete
        
        # Optional: Print status message
        puts "Frame $frm completed"
    }
    
    # Close the output file
    close $output
}

# Run the lab_coords procedure
lab_coords

# Exit the script
exit
# vmd -dispdev text -e script.tcl # run .tcl in tk console directly
