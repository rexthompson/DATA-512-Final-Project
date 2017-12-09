# modified from the following site:
# https://stackoverflow.com/questions/24641948/merging-csv-files-appending-instead-of-merging/24643455

#!/bin/bash
i=0                                     # file ounter
for filename in ../data/raw/transactions_by_week/ParkingTransaction_*.csv; do 
 # echo $filename
 head -1 $filename
 i=$(( $i + 1 ))                        # Increase the counter
done
