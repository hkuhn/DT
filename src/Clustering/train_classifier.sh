#
# Title:
#    train_classifier.sh
# Desc:
#    Trains a clustering classifier with data and A matrices
#    From deep belief network
#
# Example:
#    sh train_classifier.sh
#


A_MATRICES_PATH="../data/A_matrices"
BATCH_FILES_PATH="../data/batch_files"
DATAPOINTS_FILE="datapoints.npy"
MEANS_FILE="means.npy"

# Generate Datapoints
if [ -f "${DATAPOINTS_FILE}" ]; then
    echo "Skipping data point generation... file already exists"
else
    echo "Generating datapoints..."
    python scripts/generate_data_points.py
fi

# Train Classifier
if [ -f "${MEANS_FILE}" ]; then
    echo "Skipping mean points generation... file already exists"
else
    echo "Generating means..."
    python scripts/generate_means.py
fi








