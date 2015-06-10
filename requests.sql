GRANT USAGE ON * . * TO 'tanaguru'@'localhost' IDENTIFIED BY 'tanaguru';
CREATE DATABASE IF NOT EXISTS `tanaguru_db` CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON `tanaguru_db` . * TO 'tanaguru'@'localhost';
FLUSH PRIVILEGES;
