<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['prodid'];

if (isset($_POST['prodid']))
{
    $sqldelete = "DELETE FROM BOOKING WHERE EMAIL = '$email' AND PRODID='$prodid'";
}
else
{
    $sqldelete = "DELETE FROM BOOKING WHERE EMAIL = '$email'";
}
     
    if ($conn->query($sqldelete) === TRUE)
    {
       echo "success";
    }
    else 
    {
        echo "failed";
    }
?>

