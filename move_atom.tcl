#-------------------------------------------------------#
#
# The key procedure of the set. The given atom is moved
# from its initial position (r_atom) in one unit cell to
# another unit cell such that it gets the closest to the
# given set of atoms (r_mol_ref). The closest position
# to each atom in the set can be obtained analytically,
# thus, we find the closest position to each atom in 
# the set and minimize over those positions.
#
# The most elegant analytical formula for the position
# closest to a given atom of the set:
#
#   x = x - round(x/a)*a
#
# also turns out to be the fastest one computationally
# within the TcL language and is implemented in the
# subroutine below.
#
#-------------------------------------------------------#

proc move_atom_dr {r_atom r_mol_ref {dist_min 1e6}} {

    global unit_cell 

    set d_r_atom {0 0 0}

    foreach r_mol_i $r_mol_ref {
	set d_r [vecsub $r_atom $r_mol_i]

	set d_r_atom_i {}
	foreach  a $unit_cell  x_dr $d_r  {
	    lappend d_r_atom_i [expr -round($x_dr/$a)*$a]
	}
	    
	set dist [veclength2 [vecadd $d_r $d_r_atom_i]]
	if { $dist < $dist_min } then {
	    set dist_min $dist
	    set d_r_atom $d_r_atom_i
	}
  }

  return $d_r_atom
}

#-------------------------------------------------------#
#-------------------------------------------------------#

proc move_bdna {adna_tag bdna_tag} {

  global unit_cell unit_cell_half

#  set r_tag_a [lindex [$adna_tag get {x y z}] 0]
# Changed the definition above for a proper call to the
# procedure move_atom_dr

  set r_tag_a [$adna_tag get {x y z}]
  set r_tag_b [lindex [$bdna_tag get {x y z}] 0]

  set r_mov [move_atom_dr $r_tag_b $r_tag_a]

  if { [veclength2 $r_mov] == 0 } {return}

  set sel_mol [atomselect [$bdna_tag molid] "segid [$bdna_tag get segid]" frame [$bdna_tag frame]]
  $sel_mol moveby $r_mov
  $sel_mol delete
}

#-------------------------------------------------------#
#-------------------------------------------------------#

