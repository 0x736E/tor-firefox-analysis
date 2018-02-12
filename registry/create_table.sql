use forensics;

-- MUST DROP ALL TABLES BEFORE CREATING RELATIONSHIP

DROP TABLE IF EXISTS registry_baseline_usage;
DROP TABLE IF EXISTS registry_baseline_usage_firefox_install;
DROP TABLE IF EXISTS registry_baseline_usage_firefox_uninstall;
DROP TABLE IF EXISTS registry_baseline_usage_firefox_usage;
DROP TABLE IF EXISTS registry_baseline_usage_tor_install;
DROP TABLE IF EXISTS registry_baseline_usage_tor_uninstall;
DROP TABLE IF EXISTS registry_baseline_usage_tor_usage;


-- Create table: registry_value_type

DROP TABLE IF EXISTS registry_value_type;
CREATE TABLE registry_value_type (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  type VARCHAR(50) DEFAULT NULL,
  INDEX (id)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\registry_datatypes.csv'
  INTO TABLE registry_value_type
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (type);

-- Create table: registry_change_type

DROP TABLE IF EXISTS registry_change_type;
CREATE TABLE registry_change_type (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  type VARCHAR(50) DEFAULT NULL,
  INDEX (id)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\registry_changetypes.csv'
  INTO TABLE registry_change_type
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (type);

-- Create table: registry_exclude

DROP TABLE IF EXISTS registry_exclude;
CREATE TABLE registry_exclude (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  registry_key VARCHAR(300) DEFAULT NULL,
  INDEX (registry_key)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\registry_exclude.csv'
  INTO TABLE registry_exclude
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  (id, registry_key);

-- Create table: registry_baseline_usage

DROP TABLE IF EXISTS registry_baseline_usage;
CREATE TABLE registry_baseline_usage (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  registry_key VARCHAR(300) DEFAULT NULL,
  
  change_type_txt VARCHAR(300) DEFAULT NULL, 
  change_type INT,

  value_name VARCHAR(300) DEFAULT NULL,
  value_data LONGTEXT DEFAULT NULL,

  value_type_txt VARCHAR(300) DEFAULT NULL,
  value_type INT,

  value_data_changed_to LONGTEXT DEFAULT NULL,

  value_type_changed_to_txt VARCHAR(300) DEFAULT NULL,
  value_type_changed_to INT,

  key_modified_time_1_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_1 DATETIME,

  key_modified_time_2_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_2 DATETIME,

  INDEX(registry_key),
  INDEX(value_name)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\baseline_install_baseline_usage.csv'
  INTO TABLE registry_baseline_usage
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  ( registry_key,
    change_type_txt,
    value_name,
    value_data,
    value_type_txt,
    value_data_changed_to,
    value_type_changed_to_txt,
    key_modified_time_1_txt,
    key_modified_time_2_txt
  );

UPDATE registry_baseline_usage SET key_modified_time_1 = STR_TO_DATE(key_modified_time_1_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage DROP key_modified_time_1_txt;

UPDATE registry_baseline_usage SET key_modified_time_2 = STR_TO_DATE(key_modified_time_2_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage DROP key_modified_time_2_txt;

UPDATE registry_baseline_usage
  INNER JOIN registry_value_type
  ON registry_baseline_usage.value_type_txt = registry_value_type.type
  SET registry_baseline_usage.value_type = registry_value_type.id;
ALTER TABLE registry_baseline_usage DROP value_type_txt;
ALTER TABLE registry_baseline_usage
  ADD CONSTRAINT 
    FOREIGN KEY (value_type)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage
  INNER JOIN registry_value_type
  ON registry_baseline_usage.value_type_changed_to_txt = registry_value_type.type
  SET registry_baseline_usage.value_type_changed_to = registry_value_type.id;
ALTER TABLE registry_baseline_usage DROP value_type_changed_to_txt;
ALTER TABLE registry_baseline_usage
  ADD CONSTRAINT 
    FOREIGN KEY (value_type_changed_to)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage
  INNER JOIN registry_change_type
  ON registry_baseline_usage.change_type_txt = registry_change_type.type
  SET registry_baseline_usage.change_type = registry_change_type.id;
ALTER TABLE registry_baseline_usage DROP change_type_txt;

CREATE OR REPLACE VIEW
  registry_baseline_usage_exclude
AS
SELECT b.registry_key
FROM registry_baseline_usage b
WHERE b.registry_key 
IN (
  SELECT b.registry_key
  FROM registry_exclude e
  WHERE LOCATE(e.registry_key, b.registry_key)
);

CREATE OR REPLACE VIEW
 registry_baseline_usage_diff
AS
SELECT 
  * 
FROM
  registry_baseline_usage
WHERE (
  NOT (
    registry_baseline_usage.registry_key IN (
      SELECT 
        registry_baseline_usage_exclude.registry_key
      FROM
        registry_baseline_usage_exclude
    )
  )
);


-- Create table: registry_baseline_usage_firefox_install

DROP TABLE IF EXISTS registry_baseline_usage_firefox_install;
CREATE TABLE registry_baseline_usage_firefox_install (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  registry_key VARCHAR(300) DEFAULT NULL,
  
  change_type_txt VARCHAR(300) DEFAULT NULL, 
  change_type INT,

  value_name VARCHAR(300) DEFAULT NULL,
  value_data LONGTEXT DEFAULT NULL,

  value_type_txt VARCHAR(300) DEFAULT NULL,
  value_type INT,

  value_data_changed_to LONGTEXT DEFAULT NULL,

  value_type_changed_to_txt VARCHAR(300) DEFAULT NULL,
  value_type_changed_to INT,

  key_modified_time_1_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_1 DATETIME,

  key_modified_time_2_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_2 DATETIME,

  INDEX(registry_key),
  INDEX(value_name)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\baseline_usage_firefox_install.csv'
  INTO TABLE registry_baseline_usage_firefox_install
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  ( registry_key,
    change_type_txt,
    value_name,
    value_data,
    value_type_txt,
    value_data_changed_to,
    value_type_changed_to_txt,
    key_modified_time_1_txt,
    key_modified_time_2_txt
  );

UPDATE registry_baseline_usage_firefox_install SET key_modified_time_1 = STR_TO_DATE(key_modified_time_1_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_firefox_install DROP key_modified_time_1_txt;

UPDATE registry_baseline_usage_firefox_install SET key_modified_time_2 = STR_TO_DATE(key_modified_time_2_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_firefox_install DROP key_modified_time_2_txt;

UPDATE registry_baseline_usage_firefox_install
  INNER JOIN registry_value_type
  ON registry_baseline_usage_firefox_install.value_type_txt = registry_value_type.type
  SET registry_baseline_usage_firefox_install.value_type = registry_value_type.id;
ALTER TABLE registry_baseline_usage_firefox_install DROP value_type_txt;
ALTER TABLE registry_baseline_usage_firefox_install
  ADD CONSTRAINT 
    FOREIGN KEY (value_type)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_firefox_install
  INNER JOIN registry_value_type
  ON registry_baseline_usage_firefox_install.value_type_changed_to_txt = registry_value_type.type
  SET registry_baseline_usage_firefox_install.value_type_changed_to = registry_value_type.id;
ALTER TABLE registry_baseline_usage_firefox_install DROP value_type_changed_to_txt;
ALTER TABLE registry_baseline_usage_firefox_install
  ADD CONSTRAINT 
    FOREIGN KEY (value_type_changed_to)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_firefox_install
  INNER JOIN registry_change_type
  ON registry_baseline_usage_firefox_install.change_type_txt = registry_change_type.type
  SET registry_baseline_usage_firefox_install.change_type = registry_change_type.id;
ALTER TABLE registry_baseline_usage_firefox_install DROP change_type_txt;

CREATE OR REPLACE VIEW
  registry_baseline_usage_firefox_install_exclude
AS
SELECT b.registry_key
FROM registry_baseline_usage_firefox_install b
WHERE b.registry_key 
IN (
  SELECT b.registry_key
  FROM registry_exclude e
  WHERE LOCATE(e.registry_key, b.registry_key)
);

CREATE OR REPLACE VIEW
 registry_baseline_usage_firefox_install_diff
AS
SELECT 
  * 
FROM
  registry_baseline_usage_firefox_install
WHERE (
  NOT (
    registry_baseline_usage_firefox_install.registry_key IN (
      SELECT 
        registry_baseline_usage_firefox_install_exclude.registry_key
      FROM
        registry_baseline_usage_firefox_install_exclude
    )
  )
);


CREATE OR REPLACE VIEW
  registry_keyword_firefox_install_diff
AS
SELECT 
  *
FROM
  registry_baseline_usage_firefox_install_diff f
WHERE
  (
    f.registry_key LIKE "%mozilla%" OR
    f.value_name LIKE "%mozilla%" OR
    f.value_data LIKE "%mozilla%" OR
    f.value_data_changed_to LIKE "%mozilla%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%firefox%" OR
    f.value_name LIKE "%firefox%" OR
    f.value_data LIKE "%firefox%" OR
    f.value_data_changed_to LIKE "%firefox%"
  )
;


-- Create table: registry_baseline_usage_firefox_uninstall

DROP TABLE IF EXISTS registry_baseline_usage_firefox_uninstall;
CREATE TABLE registry_baseline_usage_firefox_uninstall (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  registry_key VARCHAR(300) DEFAULT NULL,
  
  change_type_txt VARCHAR(300) DEFAULT NULL, 
  change_type INT,

  value_name VARCHAR(300) DEFAULT NULL,
  value_data LONGTEXT DEFAULT NULL,

  value_type_txt VARCHAR(300) DEFAULT NULL,
  value_type INT,

  value_data_changed_to LONGTEXT DEFAULT NULL,

  value_type_changed_to_txt VARCHAR(300) DEFAULT NULL,
  value_type_changed_to INT,

  key_modified_time_1_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_1 DATETIME,

  key_modified_time_2_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_2 DATETIME,

  INDEX(registry_key),
  INDEX(value_name)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\baseline_usage_firefox_uninstall.csv'
  INTO TABLE registry_baseline_usage_firefox_uninstall
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  ( registry_key,
    change_type_txt,
    value_name,
    value_data,
    value_type_txt,
    value_data_changed_to,
    value_type_changed_to_txt,
    key_modified_time_1_txt,
    key_modified_time_2_txt
  );

UPDATE registry_baseline_usage_firefox_uninstall SET key_modified_time_1 = STR_TO_DATE(key_modified_time_1_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_firefox_uninstall DROP key_modified_time_1_txt;

UPDATE registry_baseline_usage_firefox_uninstall SET key_modified_time_2 = STR_TO_DATE(key_modified_time_2_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_firefox_uninstall DROP key_modified_time_2_txt;

UPDATE registry_baseline_usage_firefox_uninstall
  INNER JOIN registry_value_type
  ON registry_baseline_usage_firefox_uninstall.value_type_txt = registry_value_type.type
  SET registry_baseline_usage_firefox_uninstall.value_type = registry_value_type.id;
ALTER TABLE registry_baseline_usage_firefox_uninstall DROP value_type_txt;
ALTER TABLE registry_baseline_usage_firefox_uninstall
  ADD CONSTRAINT 
    FOREIGN KEY (value_type)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_firefox_uninstall
  INNER JOIN registry_value_type
  ON registry_baseline_usage_firefox_uninstall.value_type_changed_to_txt = registry_value_type.type
  SET registry_baseline_usage_firefox_uninstall.value_type_changed_to = registry_value_type.id;
ALTER TABLE registry_baseline_usage_firefox_uninstall DROP value_type_changed_to_txt;
ALTER TABLE registry_baseline_usage_firefox_uninstall
  ADD CONSTRAINT 
    FOREIGN KEY (value_type_changed_to)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_firefox_uninstall
  INNER JOIN registry_change_type
  ON registry_baseline_usage_firefox_uninstall.change_type_txt = registry_change_type.type
  SET registry_baseline_usage_firefox_uninstall.change_type = registry_change_type.id;
ALTER TABLE registry_baseline_usage_firefox_uninstall DROP change_type_txt;

CREATE OR REPLACE VIEW
  registry_baseline_usage_firefox_uninstall_exclude
AS
SELECT b.registry_key
FROM registry_baseline_usage_firefox_uninstall b
WHERE b.registry_key 
IN (
  SELECT b.registry_key
  FROM registry_exclude e
  WHERE LOCATE(e.registry_key, b.registry_key)
);

CREATE OR REPLACE VIEW
 registry_baseline_usage_firefox_uninstall_diff
AS
SELECT 
  * 
FROM
  registry_baseline_usage_firefox_uninstall
WHERE (
  NOT (
    registry_baseline_usage_firefox_uninstall.registry_key IN (
      SELECT 
        registry_baseline_usage_firefox_uninstall_exclude.registry_key
      FROM
        registry_baseline_usage_firefox_uninstall_exclude
    )
  )
);


CREATE OR REPLACE VIEW
  registry_keyword_firefox_uninstall_diff
AS
SELECT 
  *
FROM
  registry_baseline_usage_firefox_uninstall_diff f
WHERE
  (
    f.registry_key LIKE "%mozilla%" OR
    f.value_name LIKE "%mozilla%" OR
    f.value_data LIKE "%mozilla%" OR
    f.value_data_changed_to LIKE "%mozilla%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%firefox%" OR
    f.value_name LIKE "%firefox%" OR
    f.value_data LIKE "%firefox%" OR
    f.value_data_changed_to LIKE "%firefox%"
  )
;

-- Create table: registry_baseline_usage_firefox_usage

DROP TABLE IF EXISTS registry_baseline_usage_firefox_usage;
CREATE TABLE registry_baseline_usage_firefox_usage (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  registry_key VARCHAR(300) DEFAULT NULL,
  
  change_type_txt VARCHAR(300) DEFAULT NULL, 
  change_type INT,

  value_name VARCHAR(300) DEFAULT NULL,
  value_data LONGTEXT DEFAULT NULL,

  value_type_txt VARCHAR(300) DEFAULT NULL,
  value_type INT,

  value_data_changed_to LONGTEXT DEFAULT NULL,

  value_type_changed_to_txt VARCHAR(300) DEFAULT NULL,
  value_type_changed_to INT,

  key_modified_time_1_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_1 DATETIME,

  key_modified_time_2_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_2 DATETIME,

  INDEX(registry_key),
  INDEX(value_name)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\baseline_usage_firefox_usage.csv'
  INTO TABLE registry_baseline_usage_firefox_usage
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  ( registry_key,
    change_type_txt,
    value_name,
    value_data,
    value_type_txt,
    value_data_changed_to,
    value_type_changed_to_txt,
    key_modified_time_1_txt,
    key_modified_time_2_txt
  );

UPDATE registry_baseline_usage_firefox_usage SET key_modified_time_1 = STR_TO_DATE(key_modified_time_1_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_firefox_usage DROP key_modified_time_1_txt;

UPDATE registry_baseline_usage_firefox_usage SET key_modified_time_2 = STR_TO_DATE(key_modified_time_2_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_firefox_usage DROP key_modified_time_2_txt;

UPDATE registry_baseline_usage_firefox_usage
  INNER JOIN registry_value_type
  ON registry_baseline_usage_firefox_usage.value_type_txt = registry_value_type.type
  SET registry_baseline_usage_firefox_usage.value_type = registry_value_type.id;
ALTER TABLE registry_baseline_usage_firefox_usage DROP value_type_txt;
ALTER TABLE registry_baseline_usage_firefox_usage
  ADD CONSTRAINT 
    FOREIGN KEY (value_type)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_firefox_usage
  INNER JOIN registry_value_type
  ON registry_baseline_usage_firefox_usage.value_type_changed_to_txt = registry_value_type.type
  SET registry_baseline_usage_firefox_usage.value_type_changed_to = registry_value_type.id;
ALTER TABLE registry_baseline_usage_firefox_usage DROP value_type_changed_to_txt;
ALTER TABLE registry_baseline_usage_firefox_usage
  ADD CONSTRAINT 
    FOREIGN KEY (value_type_changed_to)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_firefox_usage
  INNER JOIN registry_change_type
  ON registry_baseline_usage_firefox_usage.change_type_txt = registry_change_type.type
  SET registry_baseline_usage_firefox_usage.change_type = registry_change_type.id;
ALTER TABLE registry_baseline_usage_firefox_usage DROP change_type_txt;

CREATE OR REPLACE VIEW
  registry_baseline_usage_firefox_usage_exclude
AS
SELECT b.registry_key
FROM registry_baseline_usage_firefox_usage b
WHERE b.registry_key 
IN (
  SELECT b.registry_key
  FROM registry_exclude e
  WHERE LOCATE(e.registry_key, b.registry_key)
);

CREATE OR REPLACE VIEW
 registry_baseline_usage_firefox_usage_diff
AS
SELECT 
  * 
FROM
  registry_baseline_usage_firefox_usage
WHERE (
  NOT (
    registry_baseline_usage_firefox_usage.registry_key IN (
      SELECT 
        registry_baseline_usage_firefox_usage_exclude.registry_key
      FROM
        registry_baseline_usage_firefox_usage_exclude
    )
  )
);

CREATE OR REPLACE VIEW
  registry_keyword_firefox_usage_diff
AS
SELECT 
  *
FROM
  registry_baseline_usage_firefox_usage_diff f
WHERE
  (
    f.registry_key LIKE "%mozilla%" OR
    f.value_name LIKE "%mozilla%" OR
    f.value_data LIKE "%mozilla%" OR
    f.value_data_changed_to LIKE "%mozilla%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%firefox%" OR
    f.value_name LIKE "%firefox%" OR
    f.value_data LIKE "%firefox%" OR
    f.value_data_changed_to LIKE "%firefox%"
  )
;


-- Create table: registry_baseline_usage_tor_install

DROP TABLE IF EXISTS registry_baseline_usage_tor_install;
CREATE TABLE registry_baseline_usage_tor_install (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  registry_key VARCHAR(300) DEFAULT NULL,
  
  change_type_txt VARCHAR(300) DEFAULT NULL, 
  change_type INT,

  value_name VARCHAR(300) DEFAULT NULL,
  value_data LONGTEXT DEFAULT NULL,

  value_type_txt VARCHAR(300) DEFAULT NULL,
  value_type INT,

  value_data_changed_to LONGTEXT DEFAULT NULL,

  value_type_changed_to_txt VARCHAR(300) DEFAULT NULL,
  value_type_changed_to INT,

  key_modified_time_1_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_1 DATETIME,

  key_modified_time_2_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_2 DATETIME,

  INDEX(registry_key),
  INDEX(value_name)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\baseline_usage_tor_install.csv'
  INTO TABLE registry_baseline_usage_tor_install
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  ( registry_key,
    change_type_txt,
    value_name,
    value_data,
    value_type_txt,
    value_data_changed_to,
    value_type_changed_to_txt,
    key_modified_time_1_txt,
    key_modified_time_2_txt
  );

UPDATE registry_baseline_usage_tor_install SET key_modified_time_1 = STR_TO_DATE(key_modified_time_1_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_tor_install DROP key_modified_time_1_txt;

UPDATE registry_baseline_usage_tor_install SET key_modified_time_2 = STR_TO_DATE(key_modified_time_2_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_tor_install DROP key_modified_time_2_txt;

UPDATE registry_baseline_usage_tor_install
  INNER JOIN registry_value_type
  ON registry_baseline_usage_tor_install.value_type_txt = registry_value_type.type
  SET registry_baseline_usage_tor_install.value_type = registry_value_type.id;
ALTER TABLE registry_baseline_usage_tor_install DROP value_type_txt;
ALTER TABLE registry_baseline_usage_tor_install
  ADD CONSTRAINT 
    FOREIGN KEY (value_type)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_tor_install
  INNER JOIN registry_value_type
  ON registry_baseline_usage_tor_install.value_type_changed_to_txt = registry_value_type.type
  SET registry_baseline_usage_tor_install.value_type_changed_to = registry_value_type.id;
ALTER TABLE registry_baseline_usage_tor_install DROP value_type_changed_to_txt;
ALTER TABLE registry_baseline_usage_tor_install
  ADD CONSTRAINT 
    FOREIGN KEY (value_type_changed_to)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_tor_install
  INNER JOIN registry_change_type
  ON registry_baseline_usage_tor_install.change_type_txt = registry_change_type.type
  SET registry_baseline_usage_tor_install.change_type = registry_change_type.id;
ALTER TABLE registry_baseline_usage_tor_install DROP change_type_txt;

CREATE OR REPLACE VIEW
  registry_baseline_usage_tor_install_exclude
AS
SELECT b.registry_key
FROM registry_baseline_usage_tor_install b
WHERE b.registry_key 
IN (
  SELECT b.registry_key
  FROM registry_exclude e
  WHERE LOCATE(e.registry_key, b.registry_key)
);

CREATE OR REPLACE VIEW
  registry_baseline_usage_tor_install_diff
AS
SELECT 
  * 
FROM
  registry_baseline_usage_tor_install
WHERE (
  NOT (
    registry_baseline_usage_tor_install.registry_key IN (
      SELECT 
        registry_baseline_usage_tor_install_exclude.registry_key
      FROM
        registry_baseline_usage_tor_install_exclude
    )
  )
);

CREATE OR REPLACE VIEW
  registry_keyword_tor_install_diff
AS
SELECT 
  *
FROM
  registry_baseline_usage_tor_install_diff f
WHERE
  (
    f.registry_key LIKE "%mozilla%" OR
    f.value_name LIKE "%mozilla%" OR
    f.value_data LIKE "%mozilla%" OR
    f.value_data_changed_to LIKE "%mozilla%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%firefox%" OR
    f.value_name LIKE "%firefox%" OR
    f.value_data LIKE "%firefox%" OR
    f.value_data_changed_to LIKE "%firefox%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%tor%" OR
    f.value_name LIKE "%tor%" OR
    f.value_data LIKE "%tor%" OR
    f.value_data_changed_to LIKE "%tor%"
  )
;



-- Create table: registry_baseline_usage_tor_uninstall

DROP TABLE IF EXISTS registry_baseline_usage_tor_uninstall;
CREATE TABLE registry_baseline_usage_tor_uninstall (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  registry_key VARCHAR(300) DEFAULT NULL,
  
  change_type_txt VARCHAR(300) DEFAULT NULL, 
  change_type INT,

  value_name VARCHAR(300) DEFAULT NULL,
  value_data LONGTEXT DEFAULT NULL,

  value_type_txt VARCHAR(300) DEFAULT NULL,
  value_type INT,

  value_data_changed_to LONGTEXT DEFAULT NULL,

  value_type_changed_to_txt VARCHAR(300) DEFAULT NULL,
  value_type_changed_to INT,

  key_modified_time_1_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_1 DATETIME,

  key_modified_time_2_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_2 DATETIME,

  INDEX(registry_key),
  INDEX(value_name)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\baseline_usage_tor_uninstall.csv'
  INTO TABLE registry_baseline_usage_tor_uninstall
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  ( registry_key,
    change_type_txt,
    value_name,
    value_data,
    value_type_txt,
    value_data_changed_to,
    value_type_changed_to_txt,
    key_modified_time_1_txt,
    key_modified_time_2_txt
  );

UPDATE registry_baseline_usage_tor_uninstall SET key_modified_time_1 = STR_TO_DATE(key_modified_time_1_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_tor_uninstall DROP key_modified_time_1_txt;

UPDATE registry_baseline_usage_tor_uninstall SET key_modified_time_2 = STR_TO_DATE(key_modified_time_2_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_tor_uninstall DROP key_modified_time_2_txt;

UPDATE registry_baseline_usage_tor_uninstall
  INNER JOIN registry_value_type
  ON registry_baseline_usage_tor_uninstall.value_type_txt = registry_value_type.type
  SET registry_baseline_usage_tor_uninstall.value_type = registry_value_type.id;
ALTER TABLE registry_baseline_usage_tor_uninstall DROP value_type_txt;
ALTER TABLE registry_baseline_usage_tor_uninstall
  ADD CONSTRAINT 
    FOREIGN KEY (value_type)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_tor_uninstall
  INNER JOIN registry_value_type
  ON registry_baseline_usage_tor_uninstall.value_type_changed_to_txt = registry_value_type.type
  SET registry_baseline_usage_tor_uninstall.value_type_changed_to = registry_value_type.id;
ALTER TABLE registry_baseline_usage_tor_uninstall DROP value_type_changed_to_txt;
ALTER TABLE registry_baseline_usage_tor_uninstall
  ADD CONSTRAINT 
    FOREIGN KEY (value_type_changed_to)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_tor_uninstall
  INNER JOIN registry_change_type
  ON registry_baseline_usage_tor_uninstall.change_type_txt = registry_change_type.type
  SET registry_baseline_usage_tor_uninstall.change_type = registry_change_type.id;
ALTER TABLE registry_baseline_usage_tor_uninstall DROP change_type_txt;

CREATE OR REPLACE VIEW
  registry_baseline_usage_tor_uninstall_exclude
AS
SELECT b.registry_key
FROM registry_baseline_usage_tor_uninstall b
WHERE b.registry_key 
IN (
  SELECT b.registry_key
  FROM registry_exclude e
  WHERE LOCATE(e.registry_key, b.registry_key)
);

CREATE OR REPLACE VIEW
  registry_baseline_usage_tor_uninstall_diff
AS
SELECT 
  * 
FROM
  registry_baseline_usage_tor_uninstall
WHERE (
  NOT (
    registry_baseline_usage_tor_uninstall.registry_key IN (
      SELECT 
        registry_baseline_usage_tor_uninstall_exclude.registry_key
      FROM
        registry_baseline_usage_tor_uninstall_exclude
    )
  )
);

CREATE OR REPLACE VIEW
  registry_keyword_tor_uninstall_diff
AS
SELECT 
  *
FROM
  registry_baseline_usage_tor_uninstall_diff f
WHERE
  (
    f.registry_key LIKE "%mozilla%" OR
    f.value_name LIKE "%mozilla%" OR
    f.value_data LIKE "%mozilla%" OR
    f.value_data_changed_to LIKE "%mozilla%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%firefox%" OR
    f.value_name LIKE "%firefox%" OR
    f.value_data LIKE "%firefox%" OR
    f.value_data_changed_to LIKE "%firefox%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%tor%" OR
    f.value_name LIKE "%tor%" OR
    f.value_data LIKE "%tor%" OR
    f.value_data_changed_to LIKE "%tor%"
  )
;


-- Create table: registry_baseline_usage_tor_usage

DROP TABLE IF EXISTS registry_baseline_usage_tor_usage;
CREATE TABLE registry_baseline_usage_tor_usage (
  id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  registry_key VARCHAR(300) DEFAULT NULL,

  
  change_type_txt VARCHAR(300) DEFAULT NULL, 
  change_type INT,

  value_name VARCHAR(300) DEFAULT NULL,
  value_data LONGTEXT DEFAULT NULL,

  value_type_txt VARCHAR(300) DEFAULT NULL,
  value_type INT,

  value_data_changed_to LONGTEXT DEFAULT NULL,

  value_type_changed_to_txt VARCHAR(300) DEFAULT NULL,
  value_type_changed_to INT,

  key_modified_time_1_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_1 DATETIME,

  key_modified_time_2_txt VARCHAR(30) DEFAULT NULL,
  key_modified_time_2 DATETIME,

  INDEX(registry_key),
  INDEX(value_name)
);

LOAD DATA INFILE
  'F:\\tor-investigation\\data\\registry\\baseline_usage_tor_usage.csv'
  INTO TABLE registry_baseline_usage_tor_usage
  COLUMNS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES
  ( registry_key,
    change_type_txt,
    value_name,
    value_data,
    value_type_txt,
    value_data_changed_to,
    value_type_changed_to_txt,
    key_modified_time_1_txt,
    key_modified_time_2_txt
  );

UPDATE registry_baseline_usage_tor_usage SET key_modified_time_1 = STR_TO_DATE(key_modified_time_1_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_tor_usage DROP key_modified_time_1_txt;

UPDATE registry_baseline_usage_tor_usage SET key_modified_time_2 = STR_TO_DATE(key_modified_time_2_txt, '%d/%c/%Y %H:%i:%S');
ALTER TABLE registry_baseline_usage_tor_usage DROP key_modified_time_2_txt;

UPDATE registry_baseline_usage_tor_usage
  INNER JOIN registry_value_type
  ON registry_baseline_usage_tor_usage.value_type_txt = registry_value_type.type
  SET registry_baseline_usage_tor_usage.value_type = registry_value_type.id;
ALTER TABLE registry_baseline_usage_tor_usage DROP value_type_txt;
ALTER TABLE registry_baseline_usage_tor_usage
  ADD CONSTRAINT 
    FOREIGN KEY (value_type)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_tor_usage
  INNER JOIN registry_value_type
  ON registry_baseline_usage_tor_usage.value_type_changed_to_txt = registry_value_type.type
  SET registry_baseline_usage_tor_usage.value_type_changed_to = registry_value_type.id;
ALTER TABLE registry_baseline_usage_tor_usage DROP value_type_changed_to_txt;
ALTER TABLE registry_baseline_usage_tor_usage
  ADD CONSTRAINT 
    FOREIGN KEY (value_type_changed_to)
    REFERENCES registry_value_type(id);

UPDATE registry_baseline_usage_tor_usage
  INNER JOIN registry_change_type
  ON registry_baseline_usage_tor_usage.change_type_txt = registry_change_type.type
  SET registry_baseline_usage_tor_usage.change_type = registry_change_type.id;
ALTER TABLE registry_baseline_usage_tor_usage DROP change_type_txt;

CREATE OR REPLACE VIEW
  registry_baseline_usage_tor_usage_exclude
AS
SELECT b.registry_key
FROM registry_baseline_usage_tor_usage b
WHERE b.registry_key 
IN (
  SELECT b.registry_key
  FROM registry_exclude e
  WHERE LOCATE(e.registry_key, b.registry_key)
);

CREATE OR REPLACE VIEW
  registry_baseline_usage_tor_usage_diff
AS
SELECT 
  * 
FROM
  registry_baseline_usage_tor_usage
WHERE (
  NOT (
    registry_baseline_usage_tor_usage.registry_key IN (
      SELECT 
        registry_baseline_usage_tor_usage_exclude.registry_key
      FROM
        registry_baseline_usage_tor_usage_exclude
    )
  )
);

CREATE OR REPLACE VIEW
  registry_keyword_tor_usage_diff
AS
SELECT 
  *
FROM
  registry_baseline_usage_tor_usage_diff f
WHERE
  (
    f.registry_key LIKE "%mozilla%" OR
    f.value_name LIKE "%mozilla%" OR
    f.value_data LIKE "%mozilla%" OR
    f.value_data_changed_to LIKE "%mozilla%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%firefox%" OR
    f.value_name LIKE "%firefox%" OR
    f.value_data LIKE "%firefox%" OR
    f.value_data_changed_to LIKE "%firefox%"
  )
    
    OR
    
  (
    f.registry_key LIKE "%tor%" OR
    f.value_name LIKE "%tor%" OR
    f.value_data LIKE "%tor%" OR
    f.value_data_changed_to LIKE "%tor%"
  )
;