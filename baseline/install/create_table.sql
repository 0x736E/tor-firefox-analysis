use forensics;

DROP TABLE IF EXISTS baseline_files;
CREATE TABLE baseline_files (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  filename VARCHAR(300) DEFAULT NULL,
  filepath VARCHAR(500) DEFAULT NULL,
  size BIGINT DEFAULT NULL,
  created DATETIME,
  modified DATETIME,
  accessed DATETIME,
  created_txt VARCHAR(50) DEFAULT NULL,
  modified_txt VARCHAR(50) DEFAULT NULL,
  accessed_txt VARCHAR(50) DEFAULT NULL,
  deleted BOOLEAN DEFAULT 0,
  deleted_txt VARCHAR(3) DEFAULT "no",
  INDEX(filename),
  INDEX(filepath)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\baseline\\install\\files.csv'
  INTO TABLE baseline_files
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (filename, filepath, @size, created_txt, modified_txt, accessed_txt, deleted_txt)
  SET size = IF(@size = '', NULL, @size);

UPDATE baseline_files SET created = STR_TO_DATE(created_txt, '%Y-%b-%d %H:%i:%S.%f UTC') WHERE created_txt LIKE "%.%UTC";
UPDATE baseline_files SET created = STR_TO_DATE(created_txt, '%Y-%b-%d %H:%i:%S UTC') WHERE created_txt NOT LIKE "%.%UTC";
ALTER TABLE baseline_files DROP created_txt;

UPDATE baseline_files SET modified = STR_TO_DATE(modified_txt, '%Y-%b-%d %H:%i:%S.%f UTC') WHERE modified_txt LIKE "%.%UTC";
UPDATE baseline_files SET modified = STR_TO_DATE(modified_txt, '%Y-%b-%d %H:%i:%S UTC') WHERE modified_txt NOT LIKE "%.%UTC";
ALTER TABLE baseline_files DROP modified_txt;

UPDATE baseline_files SET accessed = STR_TO_DATE(accessed_txt, '%Y-%b-%d %H:%i:%S.%f UTC') WHERE accessed_txt LIKE "%.%UTC";
UPDATE baseline_files SET accessed = STR_TO_DATE(accessed_txt, '%Y-%b-%d %H:%i:%S UTC') WHERE accessed_txt NOT LIKE "%.%UTC";
ALTER TABLE baseline_files DROP accessed_txt;

UPDATE baseline_files SET deleted = IF(deleted_txt IS NOT NULL , IF(deleted_txt = 'yes' , 1 , 0) , 0);
ALTER TABLE baseline_files DROP deleted_txt;

DROP TABLE IF EXISTS baseline_hashes;
CREATE TABLE baseline_hashes (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  MD5 VARCHAR(32) DEFAULT NULL,
  SHA1 VARCHAR(40) DEFAULT NULL,
  filepath VARCHAR(500) DEFAULT NULL,
  INDEX(MD5), 
  INDEX(filepath)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\baseline\\install\\hash.csv'
  INTO TABLE baseline_hashes
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (MD5, SHA1, filepath);

CREATE OR REPLACE VIEW
  baseline
AS 
SELECT 
  h.id AS hash_id,
  f.id AS file_id,
  h.MD5,
  f.filepath,
  f.size,
  f.created,
  f.modified,
  f.accessed,
  f.deleted AS deleted
FROM baseline_files f
INNER JOIN baseline_hashes h
ON f.filepath=h.filepath
;
