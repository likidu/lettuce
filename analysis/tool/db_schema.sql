-- Initial script for mysql

-- mysql -uroot -p < ./db_schema.sql

use wj;

-- ############################### CREATE TABLE #############################################
-- DROP TABLE users;
-- DROP TABLE expenses;

CREATE TABLE if not exists users(
       userid VARCHAR(50) NOT NULL PRIMARY KEY,
       sourceid VARCHAR(50) NOT NULL,
       email VARCHAR(50),
       memo VARCHAR(100)
);

CREATE TABLE if not exists expenses(
       -- expenseid VARCHAR(50) NOT NULL PRIMARY KEY,  -- TODO denny
       userid VARCHAR(50) NOT NULL,
       source_expenseid VARCHAR(50) NOT NULL,
       amount float NOT NULL,
       category VARCHAR(50) NOT NULL,
       date VARCHAR(50) NOT NULL,
       latitude VARCHAR(50),
       longitude VARCHAR(50),
       notes VARCHAR(50),
       createtime datetime
);

-- ###########################################################################################

-- ################################ CREATE PROCEDURE #######################################

-- ###########################################################################################