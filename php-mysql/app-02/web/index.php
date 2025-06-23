<?php

require dirname(__DIR__) . '/vendor/autoload.php';

$basePath = dirname(__DIR__); // this gets "/var/www/html/php-sample-application"

$lastJoinedUsers = (require "$basePath/dic/users.php")->getLastJoined();

switch (require "$basePath/dic/negotiated_format.php") {
    case "text/html":
        (new Views\Layout(
            "Twitter - Newcomers", new Views\Users\Listing($lastJoinedUsers), true
        ))();
        exit;

    case "application/json":
        header("Content-Type: application/json");
        echo json_encode($lastJoinedUsers);
        exit;
}

http_response_code(406);

