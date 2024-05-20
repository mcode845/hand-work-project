<?php

$servername = "localhost";
$username = "id21923587_users";
$password = "123Mm@#8";
$dbname = "id21923587_user_database";
$table = "post";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
    return;
}

// Check if 'action' key exists in $_POST
if (isset($_POST["action"])) {
    $action = $_POST["action"];
} else {
    // Handle the case where 'action' is not set, maybe return an error message
    echo "Action not set!";
    return;
}

// If the app sends an action to create the table...
if ("CREATE_TABLE" == $action) {
    $sql = "CREATE TABLE IF NOT EXISTS $table 
        ( id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(30) NOT NULL,
        nationalid VARCHAR(30) NOT NULL,
        phonenumber VARCHAR(30) NOT NULL,
        city VARCHAR(30) NOT NULL,
        posttitle VARCHAR(30) NOT NULL,
        posttext TEXT(500) NOT NULL,
        image TEXT NOT NULL
    )";

    if ($conn->query($sql) === TRUE) {
        // Send back success message 
        echo "success";
    } else {
        echo "error";
    }
}

// These action to add post to table
if ("ADD_POST" == $action) {
    // App will be posting these values to this server
    $username = $_POST["user_name"];
    $nationalid = $_POST["national_id"];
    $phonenumber = $_POST["phone_number"];
    $city = $_POST["city"];
    $title = $_POST["post_title"];
    $posttext = $_POST["post_text"];
    $image = $_POST["image"];
  
    $image_name = uniqid() . '.png';
    $image_path = 'images/' . $image_name;
    file_put_contents($image_path, base64_decode($image));
  
    $sql = "INSERT INTO $table
        (username,nationalid,phonenumber,city, posttitle, posttext,image) 
        VALUES ('$username','$nationalid','$phonenumber','$city', '$title', '$posttext','$image_name')";
    $result = $conn->query($sql);
    echo "success";
    $conn->close();
    return;
}

// Get all posts records from the database
if ("GET_ALL" == $action) {
    $db_data = array();
    $sql = "SELECT id, username, nationalid, phonenumber, city, posttitle, posttext, image FROM $table ORDER BY id DESC";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $row['image'] = base64_encode(file_get_contents('images/' . $row['image']));
            $db_data[] = $row;
        }
        echo json_encode($db_data);
    } else {
        echo json_encode([]);
    }
    $conn->close();
    return;
}


if("DELETE_POST" == $action){
    $post_id = $_POST['POST_ID'];
    $sql = "DELETE FROM $table WHERE id = $post_id";
    if($conn->query($sql) === TRUE){
        echo "success";
    }else{
        echo "error";
    }

    $conn-> close();
    return;
}
