<?php 
error_reporting(0);
include_once ("dbconnect.php");

$sql = "SELECT * FROM z_salesdonation";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["donate"] = array();
    while ($row = $result->fetch_assoc())
    {
        $donatelist = array();
        $donatelist["sellerid"] = $row["SELLERID"];
        $donatelist["genre"] = $row["GENRE"];
        $donatelist["sales"] = $row["SALES"];
        $donatelist["donate"] = $row["DONATE"];
       
        array_push($response["donate"], $donatelist);
    }
    echo json_encode($response);
}

else
{
    echo "nodata";
}

?>