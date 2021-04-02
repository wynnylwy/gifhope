<?php
error_reporting(0);
include_once("dbconnect.php");
$carid = $_POST['proid'];


$sqldelete = "DELETE FROM CAR WHERE ID = '$carid'";
                             
if ($conn->query($sqldelete) === true)
{
    echo "success";
}

else 
{
    echo "failed";
}

//$conn->close();
?>