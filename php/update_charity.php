<?php
error_reporting(0);
include_once("dbconnect.php");
$eid = $_POST['eid'];
$name = ucwords($_POST['name']);
$start_datetime = $_POST['start_datetime'];
$end_datetime = $_POST['end_datetime'];
$received = $_POST['received'];
$target = $_POST['target'];
$genre = $_POST['genre'];
$description = $_POST['description'];
$contact = $_POST['contact'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../charityimages/'.$eid.'.jpg';
file_put_contents($path, $decoded_string);

$sqlupdate = "UPDATE z_charity SET NAME = '$name', 
                             START_DATETIME = '$start_datetime',
                             END_DATETIME = '$end_datetime',
                             GENRE = '$genre',
                             RECEIVED = '$received',
                             TARGET = '$target',
                             DESCRIPTION = '$description',
                             CONTACT = '$contact' 
              WHERE ID = '$eid'";
                             
if ($conn->query($sqlupdate) === true)  //connection checking
{
    
   if (file_put_contents ($path, $decoded_string))
    {
        echo 'success'; //with pic
    }
    else
    {
        echo 'success';  //without pic
    }
    
}

else 
{
    echo 'failed';
   
}