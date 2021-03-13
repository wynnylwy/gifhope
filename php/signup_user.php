<?php
error_reporting(0);
include_once ("dbconnect.php");
$id = $_POST['id'];
$name = $_POST['name'];
$gender = $_POST['gender'];
$email = $_POST['email'];
$contact = $_POST['contact'];
$identity = $_POST['identity'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO z_user (ID, NAME, GENDER,EMAIL,CONTACT,IDENTITY,PASSWORD) VALUES ('$id','$name','$gender','$email','$contact','$identity','$password')";

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
    $subject = 'Verification for Gifhope'; 
    $message = 'http://yitengsze.com/carVroom/php/verify.php?email='.$useremail;
    $headers = 'From: noreply@Gifhope.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>