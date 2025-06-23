<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$conn = new mysqli('10.0.2.5', 'appuser', 'securepass', 'appdb');

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected to MySQL successfully!";
?>

