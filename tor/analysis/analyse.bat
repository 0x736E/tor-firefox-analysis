@echo off

echo Exporting [tor] data...
IF EXIST tor_install_diff_exclude.csv DEL /F tor_install_diff_exclude.csv
IF EXIST tor_usage_diff_exclude.csv DEL /F tor_usage_diff_exclude.csv
IF EXIST tor_uninstall_diff_exclude.csv DEL /F tor_uninstall_diff_exclude.csv
IF EXIST tor_usage_diff_exclude_install.csv DEL /F tor_usage_diff_exclude_install.csv
mysql --defaults-extra-file="..\\..\\config.cnf" --local-infile < .\\analyse.sql
