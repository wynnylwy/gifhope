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
        $sqlpurchase = "SELECT z_purchase.PRODID, z_purchase.CQUANTITY, z_purchase.GENRE, z_product.PRICE FROM z_purchase INNER JOIN z_product ON z_purchase.PRODID = z_product.ID  WHERE z_purchase.EMAIL = '$userid'";
        $purchaseresult = $conn->query($sqlpurchase);
        if ($purchaseresult-> num_rows > 0)
        {
             
            while ($row = $purchaseresult->fetch_assoc())
            {
                $prodid = $row["PRODID"];
                $cquantity = $row["CQUANTITY"];   
               $genre = $row["GENRE"];
                
                $pr = $row["PRICE"];
                $sqlinsertpurchasehistory = "INSERT INTO z_purchasehistory (EMAIL,ORDERID,BILLID,PRODID,CQUANTITY, PRICE) VALUES ('$userid', '$orderid', '$receiptid', '$prodid', '$cquantity', '$pr')";
                $conn->query($sqlinsertpurchasehistory);
                
            //----------------------------------------------------------------//     
                $selectproduct = "SELECT * FROM z_product WHERE ID = '$prodid'";
                $productresult = $conn->query($selectproduct);
                if ($productresult-> num_rows > 0)
                {
                    while ($row = $productresult -> fetch_assoc ())
                    {
                        $productquantity = $row["QUANTITY"];
                        $prevsold = $row["SOLD"];
                        $newquantity = $productquantity - $cquantity;
                        $newsold = $prevsold + $cquantity;
                        $sqlupdatequantity = "UPDATE z_product SET QUANTITY = '$newquantity', SOLD = '$newsold' WHERE ID = '$prodid'";
                        $conn->query($sqlupdatequantity);
                    }
                }
                
                
            //----------------------------------------------------------------//
            
            $selectsales = "SELECT * from z_product where genre='$genre'";
            $salesresult = $conn->query($selectsales);
            
                if ($salesresult-> num_rows > 0)
                {
                    
                    while ($row = $salesresult -> fetch_assoc ())
                    {
                        $sellerid = $row["SELLERID"];
                        $soldsales = $row["SOLD"];
                        $pricesales = $row["PRICE"];
                         
                        $totsales = ($pricesales*$soldsales) + $totsales;
                        
                        $sales = $totsales; 
                        $donate = $sales * 0.2;
                    }
                    
                    $checksalesexist = "SELECT * from z_salesdonation where genre='$genre' LIMIT 1";
                    $salesexist = $conn->query($checksalesexist);
                    if ($salesexist-> num_rows > 0)
                    {
                        
                          $salesrow = "UPDATE z_sales SET TOTSALES= '$totsales' WHERE GENRE='$genre'";
                          
                        $salesdonaterow = "UPDATE z_salesdonation SET SALES= '$sales', DONATE = $donate WHERE GENRE='$genre'";
                        //  $donaterow = "UPDATE z_collecteddonate SET TOTDONATE= '$totdonate' WHERE GENRE='$genre'";
                    } 
                    
                    else {
                         
                         $salesrow = "INSERT INTO z_sales (SELLERID,GENRE,TOTSALES) VALUES ('$sellerid', '$genre','$totsales')";
                         $salesdonaterow = "INSERT INTO z_salesdonation (SELLERID,GENRE,SALES, DONATE) VALUES ('$sellerid', '$genre','$sales', '$donate')";
                        //  $donaterow = "INSERT INTO z_collecteddonate (SELLERID,GENRE,TOTDONATE) VALUES ('$sellerid', '$genre','$totdonate')";
                    }
                    
                    $conn->query($salesrow);
                    $conn->query($salesdonaterow);
                    
                    // $conn->query($donaterow);
                    
                    $totsales=0;
                    $sales=0;
                    $donate=0;
                    
                    //$totdonate=0;
                    
                    $donatereceipt = $amount * 0.2;
                }
            }
            
            
            //-----------------------OUT WHILE--------------------------------//
            
            
            $sqldeletebooking = "DELETE FROM z_purchase WHERE EMAIL = '$userid'";
            $sqlinsert = "INSERT INTO z_payment (ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid', '$receiptid', '$userid', '$amount')";
            $sqlinsertShopperOrder = "INSERT INTO z_shopperorder (EMAIL,BILLID,PRODID,CQUANTITY) VALUES ('$userid', '$receiptid', '$prodid', '$cquantity')";
            
            $conn->query($sqldeletebooking);
            $conn->query($sqlinsert);
            $conn->query($sqlinsertShopperOrder);
        }
        
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order ID</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><td>Donate </td><td>RM '.$donatereceipt.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to Gifhope</center></p></div></body>';
       
    }
    
    else 
    {
        echo 'Not Match!';
    }
}

?>