<?php 
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT z_product.ID, z_product.NAME, z_purchasehistory.PRICE, z_product.QUANTITY, z_product.GENRE, z_purchasehistory.CQUANTITY, z_purchasehistory.EMAIL, z_payment.TOTAL 
        FROM z_product INNER JOIN z_purchasehistory ON z_purchasehistory.PRODID = z_product.ID 
        INNER JOIN z_payment ON z_purchasehistory.ORDERID = z_payment.ORDERID  
        WHERE z_purchasehistory.ORDERID = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["purchase"] = array();
    while ($row = $result->fetch_assoc())
    {
        $purchaselist = array();
        $purchaselist["id"] = $row["ID"];
        $purchaselist["name"] = $row["NAME"];
        $purchaselist["price"] = $row["PRICE"];
        $purchaselist["quantity"] = $row["QUANTITY"]; //
        $purchaselist["genre"] = $row["GENRE"];
        $purchaselist["cquantity"] = $row["CQUANTITY"];
        $purchaselist["email"] = $row["EMAIL"]; //
        $purchaselist["total"] = $row["TOTAL"]; //
        array_push($response["purchase"], $purchaselist);
    }
    echo json_encode($response);
}

else
{
    echo "nodata";
}

?>