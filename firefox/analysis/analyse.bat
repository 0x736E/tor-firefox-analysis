@echo off

echo Exporting [firefox] data...
IF EXIST firefox_install_diff_exclude.csv DEL /F firefox_install_diff_exclude.csv
IF EXIST firefox_usage_diff_exclude.csv DEL /F firefox_usage_diff_exclude.csv
IF EXIST firefox_uninstall_diff_exclude.csv DEL /F firefox_uninstall_diff_exclude.csv
IF EXIST firefox_usage_diff_exclude_install.csv DEL /F firefox_usage_diff_exclude_install.csv
mysql --defaults-extra-file="..\\..\\config.cnf" --local-infile < .\\analyse.sql
