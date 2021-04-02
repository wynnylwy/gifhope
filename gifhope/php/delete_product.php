<?php
error_reporting(0);
include_once("dbconnect.php");
$prodid = $_POST['proid'];


$sqldelete = "DELETE FROM z_product WHERE ID = '$prodid'";
                             
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