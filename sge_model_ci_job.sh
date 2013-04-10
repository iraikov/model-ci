#!/bin/sh

# Parse the job script using this shell
#$ -S /bin/bash

# Send stdout and stderr to the same file.
#$ -j y

# Standard output and standard error files
#$ -o SHAREDDIR/model-ci.joboutputs
#$ -e SHAREDDIR/model-ci.joboutputs

# Name of the queue
#$ -q short

# Request 8G of memory per task
#$ -l h_vmem=8G

# Export the following env variables:
#$ -v HOME
#$ -v PATH
#$ -v LD_LIBRARY_PATH


echo "============== Starting model-ci ===============" 
cd SHAREDDIR

time $HOME/bin/chicken/bin/testdrive SHAREDDIR/model-ci.tombo.config 

echo "============== model-ci has ended ===============" 

TIMESTAMP=`date +%a%d%b`
cd SHAREDDIR/output/$TIMESTAMP
$HOME/bin/chicken/bin/hyde


