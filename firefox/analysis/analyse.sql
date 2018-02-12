use forensics;

SELECT 
  * 
FROM 
  firefox_install_diff_exclude
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\firefox\\analysis\\firefox_install_diff_exclude.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT 
  * 
FROM 
  firefox_usage_diff_exclude
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\firefox\\analysis\\firefox_usage_diff_exclude.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT 
  * 
FROM 
  firefox_uninstall_diff_exclude
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\firefox\\analysis\\firefox_uninstall_diff_exclude.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT 
  * 
FROM 
  firefox_usage_diff_exclude_install
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\firefox\\analysis\\firefox_usage_diff_exclude_install.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';
