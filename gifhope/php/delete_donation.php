<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$eventid = $_POST['eventid'];

if (isset($_POST['eventid']))
{
    $sqldelete = "DELETE FROM z_donation WHERE EMAIL = '$email' AND EVENTID='$eventid'";
}
else
{
    $sqldelete = "DELETE FROM z_donation WHERE EMAIL = '$email'";
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