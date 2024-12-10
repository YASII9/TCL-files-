proc lab_coords {} {
    # Load the molecular structure and trajectory files
    set mol [mol new "collagen.psf" type psf waitfor all]
    mol addfile "collagen_modified_ocu1.dcd" type dcd first 0 last -1 molid $mol waitfor all
    
    # Get the number of frames in the trajectory
    set nf [molinfo $mol get numframes]
    
    # Open the output file for writing
    set output [open CA_pull_coordinates_mod1.dat w]
    
    # List of specific CA atoms to extract coordinates from
    set atom_list {
        "serial 7"
        "serial 353"
        "serial 392"
        "serial 725"
        "serial 764"
        "serial 1097"
    }

    # Define pairs for distance calculations
    set pairs {
        {7 353}
        {392 725}
        {764 1097}
    }

    # Loop over each frame in the trajectory
    for {set frm 0} {$frm < $nf} {incr frm} {
        # Create a dictionary to store coordinates
        array set coords_dict {}

        # Loop over each atom in the list
        foreach atom_sel $atom_list {
            # Select the specific CA atom in the current frame
            set atom [atomselect $mol "$atom_sel and name CA" frame $frm]
            
            # Get the coordinates of the atom
            set atom_coords [$atom get {x y z}]
            
            # Write the coordinates to the output file
            if {[llength $atom_coords] > 0} {
                set coords [lindex $atom_coords 0]
                set serial [lindex [split $atom_sel] 1]
                set coords_dict($serial) $coords
                puts $output "frame $frm: $atom_sel coordinates: $coords"
            } else {
                puts $output "frame $frm: $atom_sel not found"
            }
            
            # Delete the atom selection to free up memory
            $atom delete
        }
        
        # Calculate distances between pairs
        foreach pair $pairs {
            set atom1 [lindex $pair 0]
            set atom2 [lindex $pair 1]
            if {[info exists coords_dict($atom1)] && [info exists coords_dict($atom2)]} {
                set coord1 $coords_dict($atom1)
                set coord2 $coords_dict($atom2)
                set dist [veclength [vecsub $coord1 $coord2]]
                puts $output "frame $frm: distance between serial $atom1 and serial $atom2: $dist"
            } else {
                puts $output "frame $frm: distance between serial $atom1 and serial $atom2 not calculated"
            }
        }
        
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

