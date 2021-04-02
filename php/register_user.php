<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,CREDIT,VERIFY) VALUES ('$name','$email','$password','$phone','0','1')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "error";
}

//http://yitengsze.com/carVroom/php/register_user.php?name=Wynny%20&email=wynnylimweiyi@gmail.com&phone=0124706387&password=123456

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for carVroom'; 
    $message = 'http://yitengsze.com/carVroom/php/verify.php?email='.$useremail;
    $headers = 'From: noreply@carVroom.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>