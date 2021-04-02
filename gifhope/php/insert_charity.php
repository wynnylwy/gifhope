<?php
error_reporting(0);
include_once("dbconnect.php");
$eid = $_POST['eid'];
$name = ucwords($_POST['name']);
$start_datetime = $_POST['start_datetime'];
$end_datetime = $_POST['end_datetime'];
$genre = $_POST['genre'];
$received = $_POST['received'];
$target = $_POST['target'];
$description = $_POST['description'];
$contact = $_POST['contact'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$path = '../charityimages/'.$eid.'.jpg';


$sqlinsert = "INSERT INTO z_charity (ID,NAME,START_DATETIME,END_DATETIME, GENRE, RECEIVED, TARGET, DESCRIPTION, CONTACT)
              VALUES ('$eid','$name','$start_datetime','$end_datetime','$genre', '$received', '$target', '$description', '$contact')";
$sqlsearch = "SELECT * FROM z_charity WHERE ID='$eid'";
$resultsearch = $conn-> query($sqlsearch);

if ($resultsearch->num_rows >0)
{
    echo 'success';
}
                            
else if ($conn->query($sqlinsert) === true)
{
    
   if (file_put_contents ($path, $decoded_string))
    {
        echo 'success';
    }
    else
    {
        echo 'failed';
    }
    
}

else 
{
    echo 'failed';
}

$conn->close();
?>