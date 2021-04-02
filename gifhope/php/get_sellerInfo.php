<?php
error_reporting(0);
include_once ("dbconnect.php");

$sellerid = $_POST['sellerid'];

if (isset($sellerid)){
   $sql = "SELECT ID, NAME, EMAIL, CONTACT FROM z_user WHERE ID ='$sellerid'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["seller"] = array();
    while ($row = $result->fetch_assoc())
    {
        $sellerInfo = array();
        $sellerInfo["sellerid"] = $row["ID"];
        $sellerInfo["name"] = $row["NAME"];
        $sellerInfo["email"] = $row["EMAIL"]; 
        $sellerInfo["contact"] = $row["CONTACT"];
       
        array_push($response["seller"], $sellerInfo);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}