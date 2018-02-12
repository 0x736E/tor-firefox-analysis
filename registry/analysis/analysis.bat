@echo off

echo Exporting [registry] data...
IF EXIST registry_keyword_tor_install_diff.csv DEL /F registry_keyword_tor_install_diff.csv
IF EXIST registry_keyword_tor_usage_diff.csv DEL /F registry_keyword_tor_usage_diff.csv
IF EXIST registry_keyword_tor_uninstall_diff.csv DEL /F registry_keyword_tor_uninstall_diff.csv
IF EXIST registry_keyword_firefox_install_diff.csv DEL /F registry_keyword_firefox_install_diff.csv
IF EXIST registry_keyword_firefox_usage_diff.csv DEL /F registry_keyword_firefox_usage_diff.csv
IF EXIST registry_keyword_firefox_uninstall_diff.csv DEL /F registry_keyword_firefox_uninstall_diff.csv
mysql --defaults-extra-file="..\\..\\config.cnf" --local-infile < .\\analyse.sql
