use forensics;

SELECT 
  * 
FROM 
  baseline_usage_diff_exclude
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\baseline\\analysis\\baseline_usage_diff_exclude.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';