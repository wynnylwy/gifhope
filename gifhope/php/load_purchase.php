<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT z_product.ID, z_product.NAME, z_product.PRICE, z_product.QUANTITY,  z_product.GENRE, z_purchase.CQUANTITY FROM z_product INNER JOIN z_purchase ON z_purchase.PRODID = z_product.ID WHERE z_purchase.EMAIL = '$email' ";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["purchase"] = array();
    while ($row = $result->fetch_assoc())
    {
        $purchaselist = array();
        $purchaselist["id"] = $row["ID"];
        $purchaselist["name"] = $row["NAME"];
        $purchaselist["email"] = $row["EMAIL"]; 
        $purchaselist["price"] = $row["PRICE"];
        $purchaselist["quantity"] = $row["QUANTITY"];
        $purchaselist["genre"] = $row["GENRE"];
        $purchaselist["cquantity"] = $row["CQUANTITY"];
        $purchaselist["yourprice"] = round(doubleval($row["PRICE"])*(doubleval($row["CQUANTITY"])),2)."";
        array_push($response["purchase"], $purchaselist);
    }
    echo json_encode($response);
}
else
{
    echo "Purchase Empty";
}