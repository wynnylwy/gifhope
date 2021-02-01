<?php
$servername = "localhost";
$username   = "yitengsz_weiyi0106";
$password   = "Wynnylimweiyi0106";
$dbname     = "yitengsz_weiyi"; 

$conn = new mysqli($servername, $username, $password, $dbname); 
if ($conn->connect_error) {    
    die("Connection failed: " . $conn->connect_error); 
}
?> 

