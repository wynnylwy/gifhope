<?php 
error_reporting(0);
include_once ("dbconnect.php");

$selectedMonth = $_POST['selectedMonth'];

if (isset($selectedMonth)){
    
  $sql = "SELECT GENRE, DONATED FROM z_donated WHERE MONTHNAME(DATE)= '$selectedMonth'";
    
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["donate"] = array();
    while ($row = $result->fetch_assoc())
    {
        $donatelist = array();
        $donatelist["genre"] = $row["GENRE"];
        $donatelist["donated"] = $row["DONATED"];
       
        array_push($response["donate"], $donatelist);
    }
    echo json_encode($response);
}

else
{
    echo "nodata";
}

?>