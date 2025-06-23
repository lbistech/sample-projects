<?php

return new PDO("mysql:host=10.0.2.5;dbname=appdb", "sammy", "password", [PDO::ATTR_PERSISTENT => true]);
