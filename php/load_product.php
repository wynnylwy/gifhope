<?php
error_reporting(0);
include_once ("dbconnect.php");

$name = $_POST['name'];
$genre = $_POST['genre'];


if (isset($genre)){
    if ($genre == "Recent"){
        $sql = "SELECT * FROM z_product ORDER BY DATE ASC lIMIT 30";    
    }
    else{
        $sql = "SELECT * FROM z_product WHERE GENRE = '$genre'";    
    }
}
else
{
    $sql = "SELECT * FROM z_product ORDER BY DATE ASC lIMIT 30";    
}


if (isset($name)){
   $sql = "SELECT * FROM z_product WHERE NAME LIKE  '%$name%'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["product"] = array();
    
    while ($row = $result->fetch_assoc())
    {
        $productlist = array();
        $productlist["id"] = $row["ID"];
        $productlist["name"] = $row["NAME"];
        $productlist["price"] = $row["PRICE"];
        $productlist["quantity"] = $row["QUANTITY"];
        $productlist["genre"] = $row["GENRE"];
        $productlist["description"] = $row["DESCRIPTION"];
        $productlist["date"] = $row["DATE"];
        
        $response["product"][] = $productlist;
    }

    foreach($response["product"] as &$v) {
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