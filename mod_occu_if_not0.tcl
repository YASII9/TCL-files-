proc modify_occupancy {input_pdb output_pdb new_occupancy} {
    set new_occupancy [format "%6.2f" $new_occupancy]
    set infile [open $input_pdb r]
    set outfile [open $output_pdb w]

    while {[gets $infile line] >= 0} {
        if {[string match "ATOM*" $line] || [string match "HETATM*" $line]} {
            set current_occupancy [string trim [string range $line 54 59]]
            if {$current_occupancy != "0.00"} {
                set modified_line [string range $line 0 53]$new_occupancy[string range $line 60 end]
                puts $outfile $modified_line
            } else {
                puts $outfile $line
            }
        } else {
            puts $outfile $line
        }
    }

    close $infile
    close $outfile
}

# Input and output file paths
set input_pdb "collagen_modified_ocu1.pdb"
set output_pdb "collagen_modified_ocu2.pdb"

# Modify occupancy to 0.1
modify_occupancy $input_pdb $output_pdb 0.3

puts "Occupancy modification completed. Output saved to $output_pdb"
exit
