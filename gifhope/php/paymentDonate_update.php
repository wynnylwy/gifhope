  
 <?php 
error_reporting(0);
include_once ("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];

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
        $sqldonate = "SELECT z_donation.EVENTID, z_donation.AMOUNT, z_donation.DONOR, z_charity.GENRE FROM z_donation INNER JOIN z_charity ON z_donation.EVENTID = z_charity.ID  WHERE z_donation.EMAIL = '$userid'";
        $donateresult = $conn->query($sqldonate); 
        if ($donateresult-> num_rows > 0)
        {
            while ($row = $donateresult->fetch_assoc())
            {
                $eventid = $row["EVENTID"];
                $donateamount = $row["AMOUNT"];
                $donor = $row["DONOR"];
                $genre = $row["GENRE"];
                $sqlinsertdonatehistory = "INSERT INTO z_donatehistory (EMAIL,DONATEID,BILLID,EVENTID,AMOUNT, GENRE) VALUES ('$userid', '$orderid', '$receiptid', '$eventid', '$donateamount', '$genre')";
                $conn->query($sqlinsertdonatehistory);
                
                $selectcharity = "SELECT * FROM z_charity WHERE ID = '$eventid'";
                $charityresult = $conn->query($selectcharity); 
                if ($charityresult-> num_rows > 0)
                {
                    while ($row = $charityresult -> fetch_assoc ())
                    {
                        $received = $row["RECEIVED"];
                        $newreceived = $received + $donateamount;  
                        $sqlupdatereceived = "UPDATE z_charity SET RECEIVED = '$newreceived' WHERE ID = '$eventid'";
                        $conn->query($sqlupdatereceived);
                    }
                }
				//----------------------------------------------------------------//
				
				$selectDonate = "SELECT * from z_charity where genre='$genre'";
				$newDonateResult = $conn->query($selectDonate);
            
                if ($newDonateResult-> num_rows > 0)
                {
                    
                    while ($row = $newDonateResult -> fetch_assoc ())
                    {
                        $sameReceived = $row["RECEIVED"];
                         
                        $totReceived = $sameReceived + $totReceived;
                        
                    }
                    
                    $checkDonateExist = "SELECT * from z_donated where genre='$genre' LIMIT 1";
                    $donateExist = $conn->query($checkDonateExist);
                    if ($donateExist-> num_rows > 0)
                    {
                          
                        $donateRow = "UPDATE z_donated SET DONATED = '$totReceived' WHERE GENRE='$genre'";
                    } 
                    
                    else 
                    {
                         $donateRow = "INSERT INTO z_donated (GENRE,DONATED) VALUES ('$genre','$totReceived')";
                    }
                    
                    
                   
                    $conn->query($donateRow);
                    $totReceived=0;
                }
            }
			
			//-----------------------OUT WHILE--------------------------------//
            
            $sqldeletedonate = "DELETE FROM z_donation WHERE EMAIL = '$userid'";
            $sqlinsertdonate = "INSERT INTO z_paymentdonate (DONATEID,BILLID,USERID,TOTAL) VALUES ('$orderid', '$receiptid', '$userid', '$amount')";
            $sqlinsertShopperDonate = "INSERT INTO z_shopperdonate (EMAIL,BILLID,EVENTID,AMOUNT,GENRE) VALUES ('$userid', '$receiptid', '$eventid', '$amount', '$genre')";
            
            $conn->query($sqldeletedonate);
            $conn->query($sqlinsertdonate);
            $conn->query($sqlinsertShopperDonate);
        }
        
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Donate ID</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to Gifhope</center></p></div></body>';
       
    }
    
    else 
    {
        echo 'Not Match!';
    }
}

?>