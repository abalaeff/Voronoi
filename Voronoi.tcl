#
# Usage:
#
# echo $DCDNUM | vmd -dispdev text -e Voronoi.tcl
#

gets stdin fl_info
set dcdnum [lindex $fl_info 0]
set dcdname0 "production1-7_nonwater"
set dcdname_revised "production1-7_nonwater_Voronoi"

source move_atom.tcl

mol new Nonwater.psf type psf waitfor all
mol addfile $dcdname0.dcd last 1 waitfor all

#
# Atom selections to be used:

set adna [atomselect top "segname ADNA"]
set bdna [atomselect top "segname BDNA"]
set dnaP [atomselect top "segname ADNA BDNA and name P"]
set adna_tag [atomselect top "segname ADNA and resid 13 and name N3"]
set bdna_tag [atomselect top "segname BDNA and resid 13 and name N1"]

set sod [atomselect top "name SOD"]
#set wat [atomselect top "resname TIP3"]

animate delete all

#
# The main loop

    set dcdname "$dcdname0\_$dcdnum.dcd"
    puts "======= FILE $dcdname ======="
    
    mol addfile $dcdname type dcd waitfor all
    set numframes [molinfo top get numframes]

#
# Process the frames portion just read
#
    for {set i 0} {$i<$numframes} {incr i} {
	puts "Fixing $dcdname frame $i ..."
	molinfo top set frame $i
	set unit_cell [molinfo top get {a b c}] 

# Bring the two DNA chains together, if needed
        move_bdna $adna_tag $bdna_tag
        set dnaP_xyz [$dnaP get {x y z}]

## Move all the sodium ions to the image, closest to the DNA
	set new_r {}
	foreach sod_xyz [$sod get {x y z}] {
	    lappend new_r [vecadd $sod_xyz [move_atom_dr $sod_xyz $dnaP_xyz]]
	}
	$sod set {x y z} $new_r

## Move the water molecules in the same way
	set new_r {}
	foreach {oh_xyz h1_xyz h2_xyz} [$wat get {x y z}] {
	    set d_r_oh [move_atom_dr $oh_xyz $dnaP_xyz]
	    lappend new_r [vecadd $oh_xyz $d_r_oh]
	    lappend new_r [vecadd $h1_xyz $d_r_oh]
	    lappend new_r [vecadd $h2_xyz $d_r_oh]
	}
	$wat set {x y z} $new_r
    }

## Save the data, move on to the next file
    animate write dcd $dcdname_revised\_$dcdnum.dcd waitfor all
    animate delete all


