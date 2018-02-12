use forensics;

DROP TABLE IF EXISTS tor_uninstall_files;
CREATE TABLE tor_uninstall_files (
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
  'F:\\tor-investigation\\data\\tor\\uninstall\\files.csv'
  INTO TABLE tor_uninstall_files
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (filename, filepath, @size, created_txt, modified_txt, accessed_txt, deleted_txt)
  SET size = IF(@size = '', NULL, @size);

UPDATE tor_uninstall_files SET created = STR_TO_DATE(created_txt, '%Y-%b-%d %H:%i:%S.%f UTC') WHERE created_txt LIKE "%.%UTC";
UPDATE tor_uninstall_files SET created = STR_TO_DATE(created_txt, '%Y-%b-%d %H:%i:%S UTC') WHERE created_txt NOT LIKE "%.%UTC";
ALTER TABLE tor_uninstall_files DROP created_txt;

UPDATE tor_uninstall_files SET modified = STR_TO_DATE(modified_txt, '%Y-%b-%d %H:%i:%S.%f UTC') WHERE modified_txt LIKE "%.%UTC";
UPDATE tor_uninstall_files SET modified = STR_TO_DATE(modified_txt, '%Y-%b-%d %H:%i:%S UTC') WHERE modified_txt NOT LIKE "%.%UTC";
ALTER TABLE tor_uninstall_files DROP modified_txt;

UPDATE tor_uninstall_files SET accessed = STR_TO_DATE(accessed_txt, '%Y-%b-%d %H:%i:%S.%f UTC') WHERE accessed_txt LIKE "%.%UTC";
UPDATE tor_uninstall_files SET accessed = STR_TO_DATE(accessed_txt, '%Y-%b-%d %H:%i:%S UTC') WHERE accessed_txt NOT LIKE "%.%UTC";
ALTER TABLE tor_uninstall_files DROP accessed_txt;

UPDATE tor_uninstall_files SET deleted = IF(deleted_txt IS NOT NULL , IF(deleted_txt = 'yes' , 1 , 0) , 0);
ALTER TABLE tor_uninstall_files DROP deleted_txt;

DROP TABLE IF EXISTS tor_uninstall_hashes;
CREATE TABLE tor_uninstall_hashes (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  MD5 VARCHAR(32) DEFAULT NULL,
  SHA1 VARCHAR(40) DEFAULT NULL,
  filepath VARCHAR(500) DEFAULT NULL,
  INDEX(MD5),
  INDEX(filepath)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\tor\\uninstall\\hash.csv'
  INTO TABLE tor_uninstall_hashes
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (MD5, SHA1, filepath);

CREATE OR REPLACE VIEW 
  tor_uninstall
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
FROM tor_uninstall_files f
INNER JOIN tor_uninstall_hashes h
ON f.filepath=h.filepath
;

CREATE OR REPLACE VIEW
  tor_uninstall_newfiles
AS
SELECT * 
FROM tor_uninstall 
WHERE filepath 
NOT IN (
  SELECT filepath FROM baseline
);

CREATE OR REPLACE VIEW 
  tor_uninstall_changes AS
SELECT 
  f.file_id,
  b.MD5 as baseline_MD5,
  f.MD5 AS current_MD5,
  f.filepath,
  f.size,
  f.created,
  f.modified,
  f.accessed,
  f.deleted AS deleted
FROM tor_uninstall f
JOIN baseline b ON f.filepath = b.filepath
WHERE f.filepath 
IN (
  SELECT f.filepath FROM baseline WHERE
  f.MD5 != b.MD5 OR
  f.modified != b.modified OR
  f.created != b.created OR
  f.deleted != b.deleted
);

CREATE OR REPLACE VIEW
  tor_uninstall_deleted
AS
SELECT 
  f.file_id,
  b.MD5 as baseline_MD5,
  f.MD5 AS current_MD5,
  f.filepath,
  f.created,
  f.modified,
  f.accessed,
  f.deleted AS deleted
FROM tor_uninstall f
JOIN baseline b ON f.filepath = b.filepath
WHERE f.filepath 
IN (
  SELECT f.filepath FROM baseline WHERE
  f.deleted = 1 AND
  f.deleted != b.deleted
);

CREATE OR REPLACE VIEW
  tor_uninstall_exclude
AS
SELECT b.filepath
FROM tor_uninstall b
WHERE b.filepath 
IN (
  SELECT b.filepath
  FROM exclude e
  WHERE LOCATE(e.filepath, b.filepath)
);

CREATE OR REPLACE VIEW 
  tor_uninstall_diff
AS
  SELECT 
    current_MD5 as MD5,
    filepath,
    size,
    created,
    modified,
    accessed,
    deleted
  FROM
    tor_uninstall_changes
UNION
  SELECT 
    MD5,
    filepath,
    size,
    created,
    modified,
    accessed,
    deleted
  FROM
    tor_uninstall_newfiles
;

CREATE OR REPLACE VIEW
 tor_uninstall_diff_exclude
AS
SELECT 
  MD5,
  filepath,
  size,
  created,
  modified,
  accessed,
  deleted
FROM 
  tor_uninstall_diff 
WHERE 
  filepath 
  NOT IN (
    SELECT filepath FROM tor_uninstall_exclude
  )
order by filepath;