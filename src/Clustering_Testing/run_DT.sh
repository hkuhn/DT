#
# Title:
#    run_DT.sh
# Desc:
#    Runs daytrading software
#    Must be TRAINED prior to calling this script
#    Can be run via an external file or LIVE
#
# Example:
#    sh run_DT.sh <online or offline> <interval>
#


MODE="${1}"
INTERVAL="${2}"


MEANS_PATH="../Clustering"
DATA_PATH="../data"
WEIGHTS_PATH="${DATA}/A_matrics"



# RUN TRADING APPLICATION
if [ "${MODE}" = "offline" ]; then
    #OFFLINE MODE
    echo "Running application offline..."
    echo "Please specify the filename from which you want to extract data from for testing. This file should be raw data from source: "
    read FILENAME

    echo "Parsing file..."
    echo "Outfile should have sets of 60 nodes broken by 15 minute intervals. In other words, each set should have 45 identical values as the previous set."
    python scripts/parse_data.py "${FILENAME}" "${INTERVAL}"

    echo "Generating groupings..."
    echo "where is the test numpy file: "
    read TESTFILE
    python scripts/test_data.py "${TESTFILE}"

elif [ "${MODE}" = "online" ]; then
    # ONLINE MODE
    echo "Running application online..."
fi









