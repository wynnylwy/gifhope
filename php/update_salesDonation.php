<?php
error_reporting(0);
include_once ("dbconnect.php");
$sellerid = $_POST['sellerid'];
$genre = $_POST['genre'];
$sales = $_POST['sales'];
$donate = $_POST['donate'];


$sqlsearch = "SELECT * FROM z_salesdonation WHERE SELLERID = '$sellerid' AND GENRE= '$genre'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) 
{
    while ($row = $result ->fetch_assoc()){
        $rowsales = $row["SALES"];
        $rowdonate = $row["DONATE"];
    }
    
    $rowsales = $rowsales - $donate;
    
    $sqlinsert = "UPDATE z_salesdonation SET SALES = '$rowsales' WHERE SELLERID = '$sellerid' AND GENRE= '$genre'";
    $sqlupdatesales = "UPDATE z_sales SET TOTSALES = '$rowsales' WHERE SELLERID = '$sellerid' AND GENRE= '$genre'";
    
    $checkDonateExist = "SELECT * from z_collecteddonate where genre='$genre' LIMIT 1";
                    
    $donateexist = $conn->query($checkDonateExist);
                    if ($donateexist-> num_rows > 0)
                    {
                          $donaterow = "UPDATE z_collecteddonate SET TOTDONATE= '$donate' WHERE GENRE='$genre'";
                    } 
                    
                    else 
                    {
                          $donaterow = "INSERT INTO z_collecteddonate (SELLERID,GENRE,TOTDONATE) VALUES ('$sellerid', '$genre','$donate')";
                    }
                    
    $conn->query($sqlupdatesales);
    $conn->query($donaterow);
}


if ($conn->query($sqlinsert) === true)
{
    $sqlshow = "SELECT * FROM z_salesdonation WHERE SELLERID = '$sellerid' AND GENRE= '$genre'";
    $resultq = $conn->query($sqlshow);
    
    if ($resultq->num_rows > 0)
    {
        $salesnow = 0;
        while ($row = $resultq->fetch_assoc())
        {
             $salesnow = $row["SALES"] + $salesnow;
        }
    }
    
    $salesnow = $salesnow;
    echo "success, now sales=".$salesnow;
}
else
{
    echo "failed";
}

?>