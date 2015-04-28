<?php
	ignore_user_abort(FALSE);
	
	$connection = mysql_connect("localhost", "root", "");// Establishing Connection with Server 
	$db = mysql_select_db("company", $connection);// Selecting Database
	
	session_start();// Starting Session
	$timestamp_check=$_SESSION['timestamp'];// Fetch Session
	session_write_close();
	
	$count = 0;
	$maxiter=59;
	
	do{	// wait until the timestamp has been acknowledged by an iphone and posted back to the database
		if (connection_status() != CONNECTION_NORMAL){
			$count = $maxiter;
			break;
		}	
		$query = mysql_query("select * from token where timestamp='$timestamp_check'", $connection);
		$rows = mysql_num_rows($query);
		$count = $count + 1;
		print ' ';
		ob_flush();
		flush();
		sleep(1);
	} while (($rows < 1) and ($count < $maxiter));


	if ($rows == 0)
	{
		mysql_close($connection); // Closing Connection to database
		exit("<script>location.href = 'qr.php'</script>");
	}
	else
	{
		$deviceid = mysql_fetch_assoc($query);
		$deviceid = $deviceid['deviceid'];
		$query = mysql_query("delete from token where timestamp='$timestamp_check'", $connection);

	}	

	
?>
