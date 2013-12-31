#!/bin/sh
# Title:
#    load_training_data.sh
#
# Desc: 
#    The following script sets up the training of the deep belief network by retrieving
#    data from google straight from a curl command, and then parses it into pickled format
#    ready to be inputted into the DBN
#
# Example:
#    sh load_training_data.sh
#
#


DATA_DIR="../data"
TRAINING_DATA_DIR="${DATA_DIR}/training_data"
BATCH_DATA_DIR="${DATA_DIR}/batch_files"
SCRIPT_DIR="scripts"




# test if training data has been downloaded
if [ -d "${TRAINING_DATA_DIR}" ]; then
	# test if the user wants to overwrite the data folder
	echo "The training data seems to have already been downloaded. Would you like to overrwrite this data and re-download the data? Type y/n"
	read input
	if [ "${input}" = "y" ]; then
		# re-download data
		sh "${SCRIPT_DIR}/download_data.sh"

	else
		echo "Continuing with data in the folder..."
	fi
else
	mkdir "${DATA_DIR}/training_data"
	echo "Retrieving data from Google servers..."
	# download data
	sh "${SCRIPT_DIR}/download_data.sh"
fi


# test if batch files have been generated
if [ -d "${BATCH_DATA_DIR}" ]; then
	# test if the user wants to overwrite the batch files folder
	echo "The batch files seem to have already been generated. Would you like to overwrite this data and remake the batch files? Type y/n"
	read input
	if [ "${input}" = "y" ]; then
	        echo "Generating batch files..."
        	for f in ${TRAINING_DATA_DIR}/*
        	do
			python "${SCRIPT_DIR}/parse_data.py" $(basename "${f}") 60
        	done
		echo "Merging batch files..."
		python "${SCRIPT_DIR}/combine_batch_data.py"
	else
		echo "Continuing with data in the folder..."
	fi
else
	mkdir "${BATCH_DATA_DIR}"
	echo "Generating batch files..."
	for f in ${TRAINING_DATA_DIR}/*
	do
		python "${SCRIPT_DIR}/parse_data.py" $(basename "${f}") 60
	done
        echo "Merging batch files..."
	python "${SCRIPT_DIR}/combine_batch_data.py"

fi




