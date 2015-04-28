<?php
include('../phpqrcode/qrlib.php');

	$tempDir = sys_get_temp_dir().DIRECTORY_SEPARATOR; 
	session_start(); // Starting Session
	if(isset($_SESSION['timestamp'])){
		unset($_SESSION['timestamp']);
	}
    	$codeContents = (string)time(); 
	$_SESSION['timestamp']=$codeContents;

		
    	// generating QR code
    	QRcode::png($codeContents, $tempDir.'QR_timestamp.png', QR_ECLEVEL_L, 16); 
         
	header('Refresh: 1; URL=profile.php'); 
?>

<!DOCTYPE html>
<html>
    	<!-- displayingl QR code -->
	<div align="center">
		<?php echo '<img src="localtmp/QR_timestamp.png" />'; ?>
	</div>
</html>


