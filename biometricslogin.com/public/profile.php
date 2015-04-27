<?php
include('session.php');

#	$connection = mysql_connect("localhost", "root", "");// Establishing Connection with Server 
#	$db = mysql_select_db("company", $connection);// Selecting Database
#	$query = mysql_query("select * from login where username='$deviceid'", $connection);
#	$rows = mysql_num_rows($query);


?>
<!DOCTYPE html>
<html>
	<head>
		<title>Your Home Page</title>
		<link href="style.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<div id="profile">
			<b id="welcome">Welcome : <i><?php echo $deviceid; ?></i></b>
			<b id="logout"><a href="logout.php">Log Out</a></b>
		</div>
	</body>

</html>

