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

mysql -u root < export.sql && echo "Import of 'export.sql' successful"
mysql -u root < storedprocedure_triggers_views.sql && echo "Import of 'storedprocedure_triggers_views.sql' successful"

echo
echo "*****************************************"
echo "Step 3/3: Starting python app"
echo "*****************************************"
echo

python3 app.py
