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
$sold = "0";
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../carsimages/'.$carid.'.jpg';


$sqlinsert = "INSERT INTO CAR (ID,NAME,PRICE,QUANTITY, SOLD,TYPE,SPECIFICATION,SEATS_NUM,DOORS_NUM,AIR_COND, AIR_BAG, LUGGAGE, DESCRIPTION, BRAND)
              VALUES ('$carid','$carname','$price','$quantity', '$sold','$type','$specification','$seats','$doors', '$aircond', '$airbag', '$luggage', '$description','$brand')";
$sqlsearch = "SELECT * FROM CAR WHERE ID='$carid'";
$resultsearch = $conn-> query($sqlsearch);

if ($resultsearch->num_rows >0)
{
    echo 'success';
}
                            
else if ($conn->query($sqlinsert) === true)
{
    
   if (file_put_contents ($path, $decoded_string))
    {
        echo 'success';
    }
    else
    {
        echo 'failed';
    }
    
}

else 
{
    echo 'failed';
}

$conn->close();
?>