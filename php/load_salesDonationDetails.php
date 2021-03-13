<?php 
error_reporting(0);
include_once ("dbconnect.php");
$genre = $_POST['genre'];

$sql = "SELECT * FROM z_salesdonation WHERE GENRE = '$genre'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["sales"] = array();
    while ($row = $result->fetch_assoc())
    {
        $saleslist = array();
        $saleslist["sellerid"] = $row["SELLERID"];
        $saleslist["genre"] = $row["GENRE"];
        $saleslist["sales"] = $row["SALES"];
        $saleslist["donate"] = $row["DONATE"];
       
        array_push($response["sales"], $saleslist);
    }
    echo json_encode($response);
}

else
{
    echo "nodata";
}

?>