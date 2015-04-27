<?php
include('../phpqrcode/qrlib.php');

	session_start(); // Starting Session
	if(isset($_SESSION['timestamp'])){
		unset($_SESSION['timestamp']);
	}

	$tempDir = sys_get_temp_dir().DIRECTORY_SEPARATOR; 
    	$codeContents = (string)time(); 
	$codeContents = '1430102948';
	$_SESSION['timestamp']=$codeContents;
    	// generating 
    	QRcode::png($codeContents, $tempDir.'QR_timestamp.png', QR_ECLEVEL_L, 8); 
         
    	// displaying 
	echo '<img src="localtmp/QR_timestamp.png" />'; 


	header('Refresh: 2; URL=profile.php'); 
?>



