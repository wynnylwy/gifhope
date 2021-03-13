<?php
error_reporting(0);
include_once("dbconnect.php");
$pid = $_POST['pid'];
$name = ucwords($_POST['name']);
$price = $_POST['price'];
$genre = $_POST['genre'];
$quantity = $_POST['quantity'];
$description = $_POST['description'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../productimages/'.$pid.'.jpg';
file_put_contents($path, $decoded_string);

$sqlupdate = "UPDATE z_product SET NAME = '$name', 
                             PRICE = '$price',
                             GENRE = '$genre',
                             QUANTITY = '$quantity',
                             DESCRIPTION = '$description'
              WHERE ID = '$pid' ";
                             
if ($conn->query($sqlupdate) === true)
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

$conn->close();
?>