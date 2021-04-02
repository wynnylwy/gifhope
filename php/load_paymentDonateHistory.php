<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT * FROM z_paymentdonate WHERE USERID = '$email' ";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["paymentdonate"] = array();
    while ($row = $result->fetch_assoc())
    {
        $paymentDonatelist = array();
        $paymentDonatelist["donateid"] = $row["DONATEID"];
        $paymentDonatelist["billid"] = $row["BILLID"];
        $paymentDonatelist["total"] = $row["TOTAL"];
        $paymentDonatelist["date"] = $row["DATE"];
        array_push($response["paymentdonate"], $paymentDonatelist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>