<?php
error_reporting(0);
include_once ("dbconnect.php");

$monthSelected = $_POST['monthSelected'];


if (isset($monthSelected)){
    
  $sql = "SELECT GENRE, SALES, DONATE FROM z_salesdonation WHERE MONTHNAME(DATE)= '$monthSelected'";
    
}

$result = $conn->query($sql);


if ($result->num_rows > 0)
{
    $response["month"] = array();
    while ($row = $result->fetch_assoc())
    {
        $monthInfo = array();
        $monthInfo["genre"] = $row["GENRE"];
        $monthInfo["sales"] = $row["SALES"]; 
        $monthInfo["donate"] = $row["DONATE"];
       
        array_push($response["month"], $monthInfo);
    }
    echo json_encode($response);
}
else
{
    echo "$monthSelected";
    echo "nodata";
}

?>