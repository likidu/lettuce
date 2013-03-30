analysis - lettuce2数据分析
=========

## Installation
| Num | Name                                   | Comment                                                                      |
|:----|----------------------------------------|------------------------------------------------------------------------------|
|   1 | 设置环境变量                           | $WJ_HOME为github的checkout目录                                              |
|   2 | 安装mysql                              | sudo apt-get install mysql-server mysql-client libmysqlclient-dev            |
|   3 | 创建mysql的db和user                    |                                                                              |

### 创建mysql的db和user
>  mysql -u root -p
>
>   CREATE DATABASE wj CHARACTER SET utf8 COLLATE utf8_general_ci;
>
>   CREATE USER user_2013;
>
>   SET PASSWORD FOR user_2013 = PASSWORD("ilovechina");
>
>   GRANT ALL PRIVILEGES ON wj.* TO "user_2013"@"localhost" IDENTIFIED BY "ilovechina";
>
>   FLUSH PRIVILEGES;
>
>   EXIT;
