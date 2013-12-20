# Title:
#    download_data.sh
# Desc:
#    Script that downloads data from Google servers for training
#
# Example:
#    sh download_data.sh
#

DATA_DIR="../data"
TRAINING_DATA_DIR="${DATA_DIR}/training_data"


# ticker array
TICKER=( WMT KMB JNJ SCG KO ED  WM SYY CPB GIS ABT CL CAG PEP ADP UPS DTE PNW VZ MMM K WAG ITW HSY PAYX CLX NOC MSFT MDT BMS GAS GPC PG FII CMCSA CAH JPM HAL SLB IBM) 

# params
PERIOD=60
DAYS=9999

# iterate through tickers and download data
for (( i = 0; i < ${#TICKER[@]}; i++ )) do
	echo "downloading ${TICKER[i]} data..."
	curl "http://www.google.com/finance/getprices?i=${PERIOD}&p=${DAYS}d&f=d,o,h,l,c,v&df=cpct&q=${TICKER[i]}" > "${TRAINING_DATA_DIR}/${TICKER[i]}.dat"
done

# download S&P500
curl "http://www.google.com/finance/getprices?i=${PERIOD}&p=${DAYS}d&f=d,o,h,l,c,v&df=cpct&q=.INX" > "${TRAINING_DATA_DIR}/INX.dat"




