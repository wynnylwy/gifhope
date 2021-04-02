<?php 
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM z_donation WHERE EMAIL = '$email'";
$quantity = 0;
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
        $quantity = $quantity + $row["QTYDONATE"];
    }
    echo $quantity;
}

else 
{
    echo "nodata";
}

?>