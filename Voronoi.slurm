#!/bin/tcsh
#SBATCH --account=abalaeff
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --time=48:00:00
#SBATCH --error=Voronoi.log
#SBATCH --output=Voronoi.log
#SBATCH --job-name=Voronoi_JefsDNA_WT

#euser1/abalaeff[513]> catdcd production1-7_nonwater.dcd
#Read 55983 frames from file production1-7_nonwater.dcd.
#Total frames: 55983

# Use only once to split the simulation DCD file. To use, replace "if ( 0 )" with "if ( 1 )"
if ( 0 ) then
catdcd -o production1-7_nonwater_1.dcd -first 1 -last 10000 production1-7_nonwater.dcd
catdcd -o production1-7_nonwater_2.dcd -first 10001 -last 20000 production1-7_nonwater.dcd
catdcd -o production1-7_nonwater_3.dcd -first 20001 -last 30000 production1-7_nonwater.dcd
catdcd -o production1-7_nonwater_4.dcd -first 30001 -last 40000 production1-7_nonwater.dcd
catdcd -o production1-7_nonwater_5.dcd -first 40001 -last 50000 production1-7_nonwater.dcd
catdcd -o production1-7_nonwater_6.dcd -first 50001 -last 55983 production1-7_nonwater.dcd
endif

foreach i ( 1 2 3 4 5 6 )
  echo $i | vmd -dispdev text -e Voronoi.tcl >& Voronoi_$i.log &
end

wait

catdcd -o production1-7_nonwater_Voronoi.dcd production1-7_nonwater_Voronoi_[1-6].dcd

