<?php
	ignore_user_abort(FALSE);
	
	$connection = mysql_connect("localhost", "root", "");// Establishing Connection with Server 
	$db = mysql_select_db("company", $connection);// Selecting Database
	
	session_start();// Starting Session

	$timestamp_check=$_SESSION['timestamp'];// Storing Session
	$count = 0;
	$maxiter=30;
	
	do{	// wait until the timestamp has been acknowledged by an iphone and posted back to the database
		if (connection_status() != CONNECTION_NORMAL){
			$count = $maxiter;
			break;
		}	
		sleep(2);
		$query = mysql_query("select * from token where timestamp='$timestamp_check'", $connection);
		$rows = mysql_num_rows($query);
		$count = $count + 1;
		print ' ';
		ob_flush();
		flush();
	} while (($rows < 1) and ($count < $maxiter));

	if ($count == $maxiter)
	{
		mysql_close($connection); // Closing Connection
		header('Location: qr.php');
	}
	else
	{
		$deviceid = mysql_fetch_assoc($query);
		$deviceid = $deviceid['deviceid'];

//		print $timestamp_check." ".$deviceid." ";
//		print "rows".(string)$rows." ";
//		print "counts".(string)$count." ";
		$query = mysql_query("delete from token where timestamp='$timestamp_check'", $connection);

	}	

	
?>
