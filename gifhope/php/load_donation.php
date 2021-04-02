<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT z_charity.ID, z_charity.NAME, z_charity.GENRE, z_donation.EMAIL, z_donation.AMOUNT, z_donation.DONOR, z_donation.CONTACT 
           FROM z_charity INNER JOIN z_donation 
           ON z_donation.EVENTID = z_charity.ID 
           WHERE z_donation.EMAIL = '$email' ";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["donation"] = array();
    while ($row = $result->fetch_assoc())
    {
        $donationlist = array();
        $donationlist["id"] = $row["ID"];
        $donationlist["name"] = $row["NAME"];
        $donationlist["genre"] = $row["GENRE"];
        $donationlist["email"] = $row["EMAIL"]; 
        $donationlist["amount"] = $row["AMOUNT"];
        $donationlist["donor"] = $row["DONOR"];
        $donationlist["contact"] = $row["CONTACT"];
        
        array_push($response["donation"], $donationlist);
    }
    echo json_encode($response);
}
else
{
    echo "Donation Empty";
}