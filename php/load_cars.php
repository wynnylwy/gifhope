<?php
error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];
$name = $_POST['name'];
$seats = $_POST['seats'];
$specification = $_POST['specification'];


if (isset($type)){
    if ($type == "Recent"){
        $sql = "SELECT * FROM CAR ORDER BY DATE ASC lIMIT 30";    
    }
    else{
        $sql = "SELECT * FROM CAR WHERE TYPE = '$type'";    
    }
}
else
{
    $sql = "SELECT * FROM CAR ORDER BY DATE ASC lIMIT 30";    
}

if (isset($seats)){
   $sql = "SELECT * FROM CAR WHERE SEATS_NUM = '$seats'";  
}

if (isset($specification)){
   $sql = "SELECT * FROM CAR WHERE SPECIFICATION = '$specification'";  
}

if (isset($name)){
   $sql = "SELECT * FROM CAR WHERE NAME LIKE  '%$name%'";
}





$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["cars"] = array();
    while ($row = $result->fetch_assoc())
    {
        $carlist = array();
        $carlist["id"] = $row["ID"];
        $carlist["name"] = $row["NAME"];
        $carlist["price"] = $row["PRICE"];
        $carlist["quantity"] = $row["QUANTITY"];
        $carlist["sold"] = $row["SOLD"];
        $carlist["type"] = $row["TYPE"];
        $carlist["specification"] = $row["SPECIFICATION"];
        $carlist["seats"] = $row["SEATS_NUM"];
        $carlist["doors"] = $row["DOORS_NUM"];
        $carlist["aircond"] = $row["AIR_COND"];
        $carlist["airbag"] = $row["AIR_BAG"];
        $carlist["luggage"] = $row["LUGGAGE"];
        $carlist["description"] = $row["DESCRIPTION"];
        $carlist["brand"] = $row["BRAND"];
        $carlist["date"] = $row["DATE"];
        
        array_push($response["cars"], $carlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>