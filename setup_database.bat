@echo off

REM Create Database

echo Creating Database: 'forensics'
mysql --defaults-extra-file=config.cnf --local-infile < .\\create_db.sql
sleep 5

REM create table for 'exclude'

echo Creating table: 'exclude'
mysql --defaults-extra-file=config.cnf  --local-infile -D forensics < .\\exclude\\create_table.sql
sleep 5

REM create tables for 'baseline'

echo Creating table: 'baseline_install'
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\baseline\\install\\create_table.sql
sleep 5

echo Creating table: 'baseline_usage'
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\baseline\\usage\\create_table.sql
sleep 5

REM create tables for 'firefox'

echo Creating table: 'firefox_install'
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\firefox\\install\\create_table.sql
sleep 5
echo Creating table: 'firefox_uninstall'
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\firefox\\uninstall\\create_table.sql
sleep 5
echo Creating table: 'firefox_usage'
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\firefox\\usage\\create_table.sql
sleep 5
echo Creating views 'firefox' views
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\firefox\\views\\views.sql
sleep 5

REM Create tables for 'tor'

echo Creating table: 'tor_install'
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\tor\\install\\create_table.sql
sleep 5
echo Creating table: 'tor_uninstall'
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\tor\\uninstall\\create_table.sql
sleep 5
echo Creating table: 'tor_usage'
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\tor\\usage\\create_table.sql
sleep 5
echo Creating views 'tor' views
mysql --defaults-extra-file=config.cnf --local-infile -D forensics < .\\tor\\views\\views.sql
sleep 5

REM Create tables for 'registry'
echo Creating table: 'registry_*'
mysql --defaults-extra-file=config.cnf  --local-infile -D forensics < F:\\tor-investigation\\data\\registry\\create_table.sql
sleep 5
