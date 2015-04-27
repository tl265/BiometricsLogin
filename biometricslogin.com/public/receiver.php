<?php
	
	$connection = mysql_connect("localhost", "root", "");// Establishing Connection with Server 
	$db = mysql_select_db("company", $connection);// Selecting Database
	if (isset($_POST["deviceid"]) && isset($_POST["timestamp"])){
		$deviceid = $_POST["deviceid"];
		$timestamp = $_POST["timestamp"];
		$query = mysql_query("insert into token values (0, '$timestamp' , '$deviceid')", $connection);
	}

?>
