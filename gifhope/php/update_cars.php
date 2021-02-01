<?php
error_reporting(0);
include_once("dbconnect.php");
$carid = $_POST['carid'];
$carname = ucwords($_POST['carname']);
$price = $_POST['price'];
$quantity = $_POST['quantity'];
$type = $_POST['type'];
$specification = $_POST['specification'];
$seats = $_POST['seats'];
$doors = $_POST['doors'];
$aircond = $_POST['aircond'];
$airbag = $_POST['airbag'];
$luggage = $_POST['luggage'];
$description = $_POST['description'];
$brand = $_POST['brand'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../carsimages/'.$carid.'.jpg';
file_put_contents($path, $decoded_string);

$sqlupdate = "UPDATE CAR SET NAME = '$carname', 
                             PRICE = '$price',
                             QUANTITY = '$quantity',
                             TYPE = '$type',
                             SPECIFICATION = '$specification',
                             SEATS_NUM = '$seats',
                             DOORS_NUM = '$doors',
                             AIR_COND = '$aircond',
                             AIR_BAG = '$airbag',
                             LUGGAGE = '$luggage',
                             DESCRIPTION = '$description',
                             BRAND = '$brand' 
              WHERE ID = '$carid' ";
                             
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