<?php 
error_reporting(0);
include_once ("dbconnect.php");
$bookid = $_POST['bookid'];

$sql = "SELECT CAR.ID, CAR.NAME, BOOKHISTORY.PRICE, CAR.QUANTITY, CAR.TYPE, BOOKHISTORY.CQUANTITY, BOOKHISTORY.EMAIL, PAYMENT.TOTAL 
        FROM CAR INNER JOIN BOOKHISTORY ON BOOKHISTORY.CARID = CAR.ID 
        INNER JOIN PAYMENT ON BOOKHISTORY.BOOKID = PAYMENT.BOOKID  
        WHERE BOOKHISTORY.BOOKID = '$bookid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["bookings"] = array();
    while ($row = $result->fetch_assoc())
    {
        $bookinglist = array();
        $bookinglist["id"] = $row["ID"];
        $bookinglist["name"] = $row["NAME"];
        $bookinglist["price"] = $row["PRICE"];
        $bookinglist["quantity"] = $row["QUANTITY"]; //
        $bookinglist["type"] = $row["TYPE"];
        $bookinglist["cquantity"] = $row["CQUANTITY"];
        $bookinglist["email"] = $row["EMAIL"]; //
        $bookinglist["total"] = $row["TOTAL"]; //
        array_push($response["bookings"], $bookinglist);
    }
    echo json_encode($response);
}

else
{
    echo "nodata";
}

?>