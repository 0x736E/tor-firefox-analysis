@echo off

echo Exporting data...
IF EXIST baseline_usage_diff_exclude.csv DEL /F baseline_usage_diff_exclude.csv
mysql --defaults-extra-file="..\\..\\config.cnf" --local-infile < .\\analyse.sql
