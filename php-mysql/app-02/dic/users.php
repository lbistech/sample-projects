<?php

require_once dirname(__DIR__) . '/src/Service/UsersService.php';
require_once dirname(__DIR__) . '/src/Entity/User.php'; // If needed

use Service\UsersService;

// Assuming you also have a db-connection.php
$db = require dirname(__DIR__) . '/config-dev/db-connection.php';

return new UsersService($db);
