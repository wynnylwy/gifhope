<?php 
error_reporting(0);
include_once ("dbconnect.php");
$donateid = $_POST['donateid'];  

$sql = "SELECT z_charity.ID, z_charity.NAME, z_charity.GENRE, z_donatehistory.EMAIL, z_paymentdonate.TOTAL 
        FROM z_charity INNER JOIN z_donatehistory ON z_donatehistory.EVENTID = z_charity.ID 
        INNER JOIN z_paymentdonate ON z_donatehistory.DONATEID = z_paymentdonate.DONATEID  
        WHERE z_donatehistory.DONATEID  = '$donateid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["donate"] = array();
    while ($row = $result->fetch_assoc())
    {
        $donatelist = array();
        $donatelist["id"] = $row["ID"];
        $donatelist["name"] = $row["NAME"];
        $donatelist["genre"] = $row["GENRE"];
        $donatelist["email"] = $row["EMAIL"]; 
        $donatelist["total"] = $row["TOTAL"]; 
        array_push($response["donate"], $donatelist);
    }
    echo json_encode($response);
}

else
{
    echo "nodata";
}

?>