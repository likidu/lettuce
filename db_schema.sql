-- Initial script for mysql

-- /usr/bin/mysql -uroot -p

use wj;

-- ############################### CREATE TABLE #############################################
CREATE TABLE if not exists expenses(
       userid VARCHAR(50) NOT NULL PRIMARY KEY,
       source_expenseid VARCHAR(50),
       amount float,
       category VARCHAR(50),
       date TIMESTAMP NOT NULL DEFAULT NOW(),
       branding VARCHAR(50),
       latitude FLOAT,
       LONGITUDE FLOAT,
       NOTES VARCHAR(200)
);
CREATE INDEX expense_date_index ON expenses (date) USING BTREE;
-- ###########################################################################################