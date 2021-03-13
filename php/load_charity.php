<?php
error_reporting(0);
include_once ("dbconnect.php");

$name = $_POST['name'];
$genre = $_POST['genre'];


if (isset($genre)){
    if ($genre == "Recent"){
        $sql = "SELECT * FROM z_charity ORDER BY ID ASC lIMIT 30";    
    }
    else{
        $sql = "SELECT * FROM z_charity WHERE genre = '$genre'";    
    }
}
else
{
    $sql = "SELECT * FROM z_charity ORDER BY ID ASC lIMIT 30";    
}


if (isset($name)){
   $sql = "SELECT * FROM z_charity WHERE NAME LIKE  '%$name%'";
}





$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["charity"] = array();
    while ($row = $result->fetch_assoc())
    {
        $charitylist = array();
        $charitylist["id"] = $row["ID"];
        $charitylist["name"] = $row["NAME"];
        $charitylist["start_datetime"] = $row["START_DATETIME"];
        $charitylist["end_datetime"] = $row["END_DATETIME"];
        $charitylist["genre"] = $row["GENRE"];
        $charitylist["received"] = $row["RECEIVED"];
        $charitylist["target"] = $row["TARGET"];
        $charitylist["description"] = $row["DESCRIPTION"];
        $charitylist["contact"] = $row["CONTACT"];
        
        $response["charity"][] = $charitylist;
    }
    
    foreach($response["charity"] as &$v) 
    {
        $v['description'] = utf8_encode($v['description']);
    }
    
    $header = "Content-Type: application/json; charset=utf-8";
    header($header);
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>