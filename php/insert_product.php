<?php
error_reporting(0);
include_once("dbconnect.php");
$pid = $_POST['pid'];
$name = ucwords($_POST['name']);
$price = $_POST['price'];
$genre = $_POST['genre'];
$quantity = $_POST['quantity'];
$description = $_POST['description'];
$sold = "0";
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../productimages/'.$pid.'.jpg';

// chg!
$sqlinsert = "INSERT INTO z_product (ID,NAME,PRICE,QUANTITY, SOLD,GENRE, DESCRIPTION)
              VALUES ('$pid','$name','$price','$quantity', '$sold','$genre', '$description')";
$sqlsearch = "SELECT * FROM z_product WHERE ID='$pid'";
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