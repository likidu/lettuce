-- Initial script for mysql

-- /usr/bin/mysql -uroot -p

use wj;

-- ############################### CREATE TABLE #############################################
CREATE TABLE if not exists expenses(
       expenseid bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'pk',
       userid VARCHAR(50) NOT NULL,
       source_expenseid VARCHAR(50),
       amount float,
       category VARCHAR(50),
       -- date TIMESTAMP NOT NULL DEFAULT NOW(),
       date VARCHAR(50),
       createtime VARCHAR(50),
       branding VARCHAR(50),
       latitude FLOAT,
       LONGITUDE FLOAT,
       NOTES VARCHAR(200),
       memo VARCHAR(200),
       primary key(expenseid)
);
CREATE INDEX expense_date_index ON expenses (date) USING BTREE;

CREATE TABLE if not exists eventlogs(
       userid VARCHAR(50) NOT NULL,
       event VARCHAR(50) NOT NULL,
       time VARCHAR(50),
       message VARCHAR(200)
);

CREATE TABLE if not exists userindex(
       userid VARCHAR(50) NOT NULL,
       index VARCHAR(50) NOT NULL,
       value VARCHAR(50),
       updatetime VARCHAR(200)
);

-- userprofile table's schema may be changed all the times
CREATE TABLE if not exists userprofile(
       userid VARCHAR(50) NOT NULL,
       isiphone float, -- >0.5 is iphone user
       gender float, -- >0.5 is male
);

-- ###########################################################################################