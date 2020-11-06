#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=16
#SBATCH --time=12:00:00
#SBATCH --partition=parallel 
#SBATCH -A auble_rivanna

module load bcl2fastq2/2.20.0

bcl2fastq
