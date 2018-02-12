use forensics;

SELECT 
  * 
FROM 
  tor_install_diff_exclude
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\tor\\analysis\\tor_install_diff_exclude.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT 
  * 
FROM 
  tor_usage_diff_exclude
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\tor\\analysis\\tor_usage_diff_exclude.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT 
  * 
FROM 
  tor_uninstall_diff_exclude
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\tor\\analysis\\tor_uninstall_diff_exclude.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT 
  * 
FROM 
  tor_usage_diff_exclude_install
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\tor\\analysis\\tor_usage_diff_exclude_install.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

