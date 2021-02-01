<?php
error_reporting (0);

$email = $_GET['email'];
$mobile = $_GET['mobile'];
$name = $_GET['name'];
$amount = $_GET['amount'];
$bookid = $_GET['bookid'];

$api_key = '29b866e7-bdc0-4281-bff4-714a78e9462b';
$collection_id = 'kacq4hdu';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';

$data = array (
            'collection_id' => $collection_id,
            'email' => $email,
            'mobile' => $mobile,
            'name' => $name,
            'amount' => $amount * 100,
            'description' => 'Payment for order ID'.$oderid,
            'callback_url' => "http://yitengsze.com/carVroom/return_url",
            'redirect_url' => "http://yitengsze.com/carVroom/php/payment_update.php?userid=$email&mobile=$mobile&amount=$amount&bookid=$bookid"
        );
        
$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

//echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>