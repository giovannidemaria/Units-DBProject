#!/bin/bash

echo
echo "*****************************************"
echo "Step 1/3: Starting mysql service"
echo "*****************************************"
echo

service mariadb start

echo
echo "*****************************************"
echo "Step 2/3: Importing sql files"
echo "*****************************************"
echo

file1 = export.sql
file2 = routines_viste_userAdmin.sql
mysql -u root < export.sql && echo "Import of 'export.sql' successful"
mysql -u root < routines_viste_userAdmin.sql && echo "Import of 'routines_viste_userAdmin.sql' successful"

echo
echo "*****************************************"
echo "Step 3/3: Starting python app"
echo "*****************************************"
echo

python3 app.py
