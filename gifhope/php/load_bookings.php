<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT CAR.ID, CAR.NAME, CAR.PRICE, CAR.QUANTITY, CAR.TYPE, BOOKING.CQUANTITY FROM CAR INNER JOIN BOOKING ON BOOKING.PRODID = CAR.ID WHERE BOOKING.EMAIL = '$email' ";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["bookings"] = array();
    while ($row = $result->fetch_assoc())
    {
        $bookinglist = array();
        $bookinglist["id"] = $row["ID"];
        $bookinglist["name"] = $row["NAME"];
        $bookinglist["email"] = $row["EMAIL"]; //
        $bookinglist["price"] = $row["PRICE"];
        $bookinglist["quantity"] = $row["QUANTITY"];
        $bookinglist["type"] = $row["TYPE"];
        $bookinglist["cquantity"] = $row["CQUANTITY"];
        $bookinglist["yourprice"] = round(doubleval($row["PRICE"])*(doubleval($row["CQUANTITY"])),2)."";
        array_push($response["bookings"], $bookinglist);
    }
    echo json_encode($response);
}
else
{
    echo "Booking Empty";
}
?>
