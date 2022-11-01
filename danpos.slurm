#!/bin/bash
#SBATCH --nodes=1 
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH -A auble_rivanna
#SBATCH --output=WT1
#SBATCH --partition=serial 

module load danpos

python /share/apps/danpos/2.2.2/danpos.py dpos /scratch/dta4n/WT1_mapq_filtered.sorted.bam