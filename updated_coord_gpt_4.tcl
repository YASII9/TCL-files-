proc lab_coords {} {
    # Check if files exist before loading
    if {![file exists "hcolA.psf"] || ![file exists "hcol_pull1.dcd"]} {
        puts stderr "Error: Required files 'hcolA.psf' or 'hcol_pull1.dcd' not found. Exiting."
        return
    }

    # Load the molecular structure and trajectory files
    set mol [mol new "hcolA.psf" type psf waitfor all]
    if {$mol == -1} {
        puts stderr "Error: Failed to load 'hcolA.psf'. Exiting."
        return
    }
    
    mol addfile "hcol_pull1.dcd" type dcd first 0 last -1 molid $mol waitfor all
    
    # Get the number of frames in the trajectory
    set nf [molinfo $mol get numframes]
    if {$nf == 0} {
        puts stderr "Error: No frames in the trajectory file. Exiting."
        return
    }

    # Open the output files for writing
    set output_coords [open "coordinates_pull1.dat" w]
    if {$output_coords == ""} {
        puts stderr "Error: Failed to create 'coordinates_pull1.dat'. Exiting."
        return
    }
    set output_dists [open "distances_pull1.dat" w]
    if {$output_dists == ""} {
        puts stderr "Error: Failed to create 'distances_pull1.dat'. Exiting."
        close $output_coords
        return
    }

    # Create a log file for tracking progress and errors
    set log_file [open "lab_coords.log" w]
    puts $log_file "Starting lab_coords procedure..."

    # List of specific CA atoms to extract coordinates from
    set atom_list {
        "serial 20"
        "serial 353"
        "serial 392"
        "serial 725"
        "serial 764"
        "serial 1097"
    }

    # Define pairs for distance calculations
    set pairs {
        {20 353}
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
            
            if {[catch {$atom num}]} {
                puts $log_file "Frame $frm: Error selecting $atom_sel. Skipping..."
                puts $output_coords "frame $frm: serial $atom_sel selection error."
                continue
            }

            # Get coordinates and check if they are valid
            set atom_coords [$atom get {x y z}]
            if {[llength $atom_coords] > 0} {
                set coords [lindex $atom_coords 0]
                set serial [lindex [split $atom_sel] 1]
                set coords_dict($serial) $coords
                puts $output_coords "frame $frm: serial $serial coordinates: $coords"
            } else {
                puts $output_coords "frame $frm: serial $atom_sel not found."
                puts $log_file "Frame $frm: Atom $atom_sel not found."
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
                puts $output_dists "frame $frm: distance between serial $atom1 and serial $atom2: $dist"
            } else {
                puts $output_dists "frame $frm: distance between serial $atom1 and serial $atom2 not calculated."
                puts $log_file "Frame $frm: Distance calculation failed for pair $atom1-$atom2."
            }
        }
        
        # Optional: Print and log status message
        puts "Frame $frm completed"
        puts $log_file "Frame $frm completed"
    }
    
    # Close the output and log files
    close $output_coords
    close $output_dists
    puts $log_file "lab_coords procedure completed successfully."
    close $log_file
}

# Run the lab_coords procedure
lab_coords

# Exit the script
exit

