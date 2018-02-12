
-- This file only contains views which depend upon other views, or other tables
-- such that there may occurr a cyclical dependency problem.
-- all other views should remain in their respective table's sql file.

use forensics;

-- TRACK CHANGES FROM INSTALL TO USAGE

CREATE OR REPLACE VIEW 
  firefox_usage_changes_install 
AS
SELECT 
  b.MD5 as baseline_MD5,
  f.MD5 AS current_MD5,
  f.filepath,
  f.size,
  f.created,
  f.modified,
  f.accessed,
  f.deleted AS deleted
FROM firefox_usage f
JOIN firefox_install b ON f.filepath = b.filepath
WHERE f.filepath 
IN (
  SELECT f.filepath FROM firefox_install WHERE
  f.MD5 != b.MD5 OR
  f.modified != b.modified OR
  f.created != b.created OR
  f.deleted != b.deleted
);

CREATE OR REPLACE VIEW
  firefox_usage_newfiles_install
AS
SELECT * 
FROM firefox_usage 
WHERE filepath 
NOT IN (
  SELECT filepath FROM firefox_install
);

CREATE OR REPLACE VIEW 
  firefox_usage_diff_install
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
    firefox_usage_changes_install
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
    firefox_usage_newfiles_install
;

CREATE OR REPLACE VIEW
  firefox_usage_diff_exclude_install
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
  firefox_usage_diff_install 
WHERE 
  filepath 
  NOT IN (
    SELECT filepath FROM firefox_usage_exclude
  )
order by filepath;