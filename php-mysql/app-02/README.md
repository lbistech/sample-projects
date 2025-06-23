# PHP 7.1 sample application

Sample PHP applications that uses:
* Dependency Injection
* Apache routing
* Composer (aka: Not reinventing the wheel)

## Requirements

* Unix-like operating systems
* Apache
* MariaDB/MySQL
* PHP >= 7.1
* Composer
* composer require willdurand/negotiation
* Command line tools `make` & `wget`

## Database 
1. Create database
2. Create user
```
CREATE USER 'sammy'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON appdb.* TO 'sammy'@'%';
FLUSH PRIVILEGES;
```
3. Create the 'sample' database and load [sql/db.sql](/sql/db.sql).
4. Update the username, password and host in db_connection.php file of code

## Setup

1. Run `make` from project root.
2. Configure Apache:
```apache
<VirtualHost *:80>
    ServerName 34.61.140.255
    DocumentRoot /var/www/html/php-sample-application/web

    <Directory /var/www/html/php-sample-application/web>
        Require all granted
        AllowOverride all
    </Directory>

<IfModule mod_php8.c>
    php_value include_path "/var/www/html/php-sample-application"
</IfModule>

</VirtualHost>
```
3. composer dump-autoload
4. 

You are all set, point your browser to http://%application.host.name%/
