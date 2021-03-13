<?php
error_reporting(0);
include_once("dbconnect.php");
$eid = $_POST['eid'];


$sqldelete = "DELETE FROM z_charity WHERE ID = '$eid'";
                             
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