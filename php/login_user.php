<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqlquantity = "SELECT * FROM z_purchase WHERE EMAIL = '$email'";

$resultq = $conn->query($sqlquantity);
$quantity = 0;
if ($resultq->num_rows > 0) 
{
    while ($rowq = $resultq ->fetch_assoc()){
        $quantity = $rowq["CQUANTITY"] + $quantity;
    }
}

//-----------------------------------------------------------------------//

$sqldonate = "SELECT * FROM z_donation WHERE EMAIL = '$email'";

$resultDonate = $conn->query($sqldonate);
$donation = 0;
if ($resultDonate->num_rows > 0) 
{
    while ($rowDonate = $resultDonate ->fetch_assoc()){
        $donation = $rowDonate["QTYDONATE"] + $donation;
    }
}

//-----------------------------------------------------------------------//

$sql = "SELECT * FROM z_user WHERE EMAIL = '$email' AND PASSWORD = '$password'";
$result = $conn->query($sql);
if ($result->num_rows > 0) 
{
    while ($row = $result ->fetch_assoc())
    {
      echo $data ="success,".$row["NAME"].",".$row["EMAIL"].",".$row["CONTACT"].",".$row["IDENTITY"].",".$row["DATEREG"].",$quantity,$donation";
    }
}
else
{
    echo "failed";
}