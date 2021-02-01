<?php 
error_reporting(0);
include_once ("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$bookid = $_GET['bookid'];

$data = array(
            'id' => $_GET['billplz']['id'],
            'paid_at' => $_GET['billplz']['paid_at'],
            'paid' => $_GET['billplz']['paid'],
            'x_signature' => $_GET['billplz']['x_signature']
        );
        
$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus == "true")
{
    $paidstatus = "Success";
}
else 
{
    $paidstatus = "Failed";
}

$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value)
{
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid')
    {
        break;
    }
    else 
    {
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, 'S-Np1OuZz_w0YbL_aDn30lAw');
if ($signed === $data['x_signature'])
{
    if ($paidstatus == "Success")
    {
        $sqlbooking = "SELECT BOOKING.PRODID, BOOKING.CQUANTITY, CAR.PRICE FROM BOOKING INNER JOIN CAR ON BOOKING.PRODID = CAR.ID  WHERE BOOKING.EMAIL = '$userid'";
        $bookingresult = $conn->query($sqlbooking);
        if ($bookingresult-> num_rows > 0)
        {
            while ($row = $bookingresult->fetch_assoc())
            {
                $prodid = $row["PRODID"];
                $cquantity = $row["CQUANTITY"];
                $pr = $row["PRICE"];
                $sqlinsertbookhistory = "INSERT INTO BOOKHISTORY (EMAIL,BOOKID,BILLID,CARID,CQUANTITY, PRICE) VALUES ('$userid', '$bookid', '$receiptid', '$prodid', '$cquantity', '$pr')";
                $conn->query($sqlinsertbookhistory);
                
                $selectcar = "SELECT * FROM CAR WHERE ID = '$prodid'";
                $carresult = $conn->query($selectcar);
                if ($carresult-> num_rows > 0)
                {
                    while ($row = $carresult -> fetch_assoc ())
                    {
                        $carquantity = $row["QUANTITY"];
                        $prevsold = $rowp["SOLD"];
                        $newquantity = $carquantity - $cquantity;
                        $newsold = $prevsold + $cquantity;
                        $sqlupdatequantity = "UPDATE CAR SET QUANTITY = '$newquantity', SOLD = '$newsold' WHERE ID = '$prodid'";
                        $conn->query($sqlupdatequantity);
                    }
                }
            }
            
            $sqldeletebooking = "DELETE FROM BOOKING WHERE EMAIL = '$userid'";
            $sqlinsert = "INSERT INTO PAYMENT (BOOKID,BILLID,USERID,TOTAL) VALUES ('$bookid', '$receiptid', '$userid', '$amount')";
            $sqlinsertCustomer = "INSERT INTO CUSTOMERORDER (EMAIL,BILLID,CARID,CQUANTITY) VALUES ('$userid', '$receiptid', '$prodid', '$cquantity')";
            
            $conn->query($sqldeletebooking);
            $conn->query($sqlinsert);
            $conn->query($sqlinsertCustomer);
        }
        
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Book ID</td><td>'.$bookid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to carVroom</center></p></div></body>';
       
    }
    
    else 
    {
        echo 'Not Match!';
    }
}

?>