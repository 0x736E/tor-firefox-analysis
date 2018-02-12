use forensics;

DROP TABLE IF EXISTS exclude;
CREATE TABLE exclude (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  MD5 VARCHAR(32) DEFAULT NULL,
  filepath VARCHAR(500) DEFAULT NULL,
  INDEX(MD5),
  INDEX(filepath)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\exclude\\exclude.csv'
  INTO TABLE exclude
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (id, MD5, filepath);
