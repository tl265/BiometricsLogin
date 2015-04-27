<?php
include('session.php');

	$db = mysql_select_db("company", $connection);// Selecting Database
	$query = mysql_query("select * from login where username='$deviceid'", $connection);
	$rows = mysql_num_rows($query);
	if ($rows == 0)
	{
		$query = mysql_query("insert into login values (0, '$deviceid' , 1)", $connection);
		$usercount = 1;
	}
	else
	{
		$query = mysql_fetch_assoc($query);
		$usercount = $query['usercount'];
		$usercount = $usercount + 1;
		$query = mysql_query("update login set usercount = '$usercount' where username = '$deviceid'", $connection);
	}	
			

?>
<!DOCTYPE html>
<html>
	<head>
		<title>Your Home Page</title>
		<link href="style.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<div id="profile">
			<b id="welcome">
			Welcome : <i><?php echo $deviceid; ?></i> <br>
			Login counts: <i><?php echo $usercount; ?></i>
			</b>
			<b id="logout"><a href="logout.php">Log Out</a></b>
		</div>
	</body>

</html>

