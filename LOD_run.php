<html>
<body>

<?php 
set_time_limit(0);

// chdir('cvs');

// // current directory
// echo getcwd() . "\n";



$myFile = 'query.fa';
$fh = fopen($myFile, 'w') or die("can't open file");
$stringData = trim($_POST['query'])."\n";

//echo $stringData;
// if ($stringData[0]!='>'){fwrite($fh, ">query\n");}
fwrite($fh, $stringData);
fclose($fh);
print $stringData;


$cmd2 ='"C:\\Program Files\\R\\R-4.0.2\\bin\\x64\\Rscript.exe " LOD_web.R';


print $cmd2;
$last_line = exec($cmd2);
print "lastline: ".$last_line;

// $cmd2 ='Rscript LOD_web.R';
// echo $cmd2;

// echo '<br>'.system('where '.$cmd3).'<br>';

echo '<h1>LOD with 95%Confidence Interval (Probit Regression)</h1> <br>';


// echo '
// // </pre>
// // <hr />Last line of the output: ' . $last_line . '
// // <hr />Return value: ' . $retval.'
// // <br />';


// $file =  "blast_out.txt"; //Path to your *.txt file
// $contents = file($file);
// $string = implode($contents);
// echo $string;
$contents = file_get_contents('LOD.txt');

echo '<pre>', $contents, '</pre>';

unlink('query.fa');
unlink('LOD.txt');
#exit();
?>
<br>
<img src="result.png" height="600" width="800">
<br>

<a href="curve.csv">Download csv file for LOD and confidence interval data for plotting</a>
</body>
</html>