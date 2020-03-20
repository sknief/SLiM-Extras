#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --mem=1000
#SBATCH --partition=regular,regularA
#SBATCH --job-name=BASIC_DRIVE
#SBATCH --output=output.txt
#SBATCH --array=1-2601

# Submits an array of SLiM jobs to a computing cluster that manages jobs with SLURM.

#  Created by Sam Champer, 2020.
#  A product of the Messer Lab, http://messerlab.org/slim/

#  Sam Champer, Ben Haller and Philipp Messer, the authors of this code, hereby
#  place the code in this file into the public domain without restriction.
#  If you use this code, please credit SLiM-Extras and provide a link to
#  the SLiM-Extras repository at https://github.com/MesserLab/SLiM-Extras.
#  Thank you.

# Create and move to working directory for job:
WORKDIR=/SSD/$USER/$JOB_ID-$SLURM_ARRAY_TASK_ID
mkdir -p $WORKDIR
cd $WORKDIR

# Copy files over to working directory:
# Replace SCRIPT_LOCATION with wherever the desired files are.
SCRIPT_LOCATION=/home/path/to/your/slim/file/and/driver/and/params  # Set this path to your own directory.
cp $SCRIPT_LOCATION/minimal_gene_drive.slim .
cp $SCRIPT_LOCATION/minimal_slim_driver.py .

# Include SLiM in the path.
PATH=$PATH:/home/path/to/your/slim/and/eidos/executables  # Set this path to your own SLiM directory.
export PATH

# The program and command line args to be run are the i-th line of params.txt,
# where i is the current task ID.
# Note that params.txt must first be generated by running
# "generate_cluster_params_file.py > params.txt" within the folder.
prog=`sed -n "${SLURM_ARRAY_TASK_ID}p" ${SCRIPT_LOCATION}/params.txt`

# Do computation
$prog > ${SLURM_ARRAY_TASK_ID}.part
cp ${SLURM_ARRAY_TASK_ID}.part $SCRIPT_LOCATION

# Clean up working directory:
rm -r $WORKDIR