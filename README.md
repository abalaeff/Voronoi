# Voronoi
A TcL script for VMD that rearranges the solvent bath around a macromolecule into a Voronoi cell

This is a TcL script written for VMD (www.ks.uiuc.edu/Research/vmd).

Target user base: people doing MD simulations of macromolecules with NAMD, CHARMM, AMBER, etc.

Purpose: see p. 8 of the file Balaeff_etal_Zip-DNA_SI.pdf 

Solution: see the script :) Basically, for each water oxygen, it is determined what location 

Usage: See Voronoi.tcl or Voronoi.slurm for command-line usage.

Voronoi.tcl : the main script, performs the Voronoi cell solvent rearrangement

move_atom.tcl : the principal subrouting of the Voronoi script, moves atoms from their old to new positions; optimized for speed.

Voronoi.slurm : performs the Voronoi solvent rearrangement for an MD trajectory; splits the trajectory into several pieces for faster calculation.

Balaeff_etal_Zip-DNA_SI.pdf : the supplementary information for our 2011 zip-DNA paper; on p.8 explains and illustrates the concept of the Voronoi cell rearrangement of water and ions around the solvated DNA.

