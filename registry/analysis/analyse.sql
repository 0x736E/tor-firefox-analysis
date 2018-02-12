use forensics;

-- Analyse: TOR

SELECT 
  * 
FROM 
  registry_keyword_tor_usage_diff
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\registry\\analysis\\registry_keyword_tor_install_diff.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT 
  * 
FROM 
  registry_keyword_tor_usage_diff
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\registry\\analysis\\registry_keyword_tor_usage_diff.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT 
  * 
FROM 
  registry_keyword_tor_uninstall_diff
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\registry\\analysis\\registry_keyword_tor_uninstall_diff.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

-- ANALYSE: Firefox

SELECT 
  * 
FROM 
  registry_keyword_firefox_install_diff
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\registry\\analysis\\registry_keyword_firefox_install_diff.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT 
  * 
FROM 
  registry_keyword_firefox_usage_diff
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\registry\\analysis\\registry_keyword_firefox_usage_diff.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT 
  * 
FROM 
  registry_keyword_firefox_uninstall_diff
LIMIT 0, 50000
INTO OUTFILE 'F:\\tor-investigation\\data\\registry\\analysis\\registry_keyword_firefox_uninstall_diff.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';