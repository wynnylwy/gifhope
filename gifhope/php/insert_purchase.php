<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['proid'];
$userquantity = $_POST['quantity'];
$genre = $_POST['genre'];


$sqlsearch = "SELECT * FROM z_purchase WHERE EMAIL = '$email' AND PRODID= '$prodid'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) 
{
    while ($row = $result ->fetch_assoc()){
        $prquantity = $row["CQUANTITY"];
    }
    $prquantity = $prquantity + $userquantity;
    $sqlinsert = "UPDATE z_purchase SET CQUANTITY = '$prquantity' WHERE PRODID = '$prodid' AND EMAIL = '$email'";
    
}
else
{
    $sqlinsert = "INSERT INTO z_purchase (EMAIL,PRODID,CQUANTITY, GENRE) VALUES ('$email','$prodid','$userquantity', '$genre')";
}

if ($conn->query($sqlinsert) === true)
{
    $sqlquantity = "SELECT * FROM z_purchase WHERE EMAIL = '$email'";
    $resultq = $conn->query($sqlquantity);
    
    if ($resultq->num_rows > 0)
    {
        $quantity = 0;
        while ($row = $resultq->fetch_assoc())
        {
            $quantity = $row["CQUANTITY"] + $quantity;
        }
    }
    
    $quantity = $quantity;
    echo "success,".$quantity;
}
else
{
    echo "failed";
}

?>