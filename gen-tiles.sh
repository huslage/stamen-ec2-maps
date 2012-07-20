export TIME="%E"
i=$*
/usr/bin/time -a -o ${i}.time tilestache-seed.py -x -c tilestache.cfg -b 38.891 -123.464 35.603 -109.072  -l solar-light ${i} > ${i}.out 2>&1 
