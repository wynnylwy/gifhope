<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$eventid = $_POST['eventid'];
$amount = $_POST['amount'];
$qtydonate = $_POST['qtydonate'];
$donor = $_POST['donor'];
$contact = $_POST['contact'];



$sqlsearch = "SELECT * FROM z_donation WHERE EMAIL = '$email' AND EVENTID= '$eventid'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) 
{
    while ($row = $result ->fetch_assoc()){
        $newamount = $row["AMOUNT"];
    }
    $newamount = $newamount + $amount;
    $sqlinsert = "UPDATE z_donation SET AMOUNT = '$newamount' WHERE EVENTID = '$eventid' AND EMAIL = '$email'";
    
}
else
{
    $sqlinsert = "INSERT INTO z_donation (EMAIL,EVENTID,AMOUNT,QTYDONATE,DONOR,CONTACT) VALUES ('$email','$eventid','$amount', '$qtydonate', '$donor', '$contact')";
}

if ($conn->query($sqlinsert) === true)
{
    $sqlquantity = "SELECT * FROM z_donation WHERE EMAIL = '$email'";
    $resultq = $conn->query($sqlquantity);
    
    if ($resultq->num_rows > 0)
    {
        $donate = 0;
        while ($row = $resultq->fetch_assoc())
        {
            $donate = $row["AMOUNT"] + $donate;
        }
    }
    
    $printdonate = $donate;
    echo "success,$printdonate,$qtydonate";
}
else
{
    echo "failed";
}

?>