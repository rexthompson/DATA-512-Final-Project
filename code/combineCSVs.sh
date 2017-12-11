# modified from the following site:
# https://stackoverflow.com/questions/24641948/merging-csv-files-appending-instead-of-merging/24643455

#!/bin/bash
OutFileName="../data/ParkingTransaction_20120101_20170930_raw.csv"  # output file name
i=0                                       			   	   	   		# file counter
for filename in ../data/raw/transactions_by_week/ParkingTransaction_*.csv; do 
 if [ "$filename"  != "$OutFileName" ] ;      			            # Avoid recursion
 then 
   if [[ $i -eq 0 ]] ; then 
      head -1  $filename >   $OutFileName # Copy header if it is the first file
   fi
   tail -n +2  $filename >>  $OutFileName # Append from the 2nd line each file
   i=$(( $i + 1 ))                        # Increase the counter
 fi
done
