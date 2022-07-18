<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
 <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  <title>LOD_Calculator</title>

  <script src="./tree/jquery/jquery.js" type="text/javascript"></script>
  <script src="./tree/jquery/jquery-ui.custom.js" type="text/javascript"></script>
  <script src="./tree/jquery/jquery.cookie.js" type="text/javascript"></script>

</head>

 <body >
  
<form name="myForm" action="LOD_run.php" method="post" onsubmit="return validateForm()">

<h1>LOD Calculator</h1>
<h3> Calculate LOD and confidence interval from serial dilution digital read out using Probit regression</h3>
Example Data<br>
First column is concentration at each dilution, such as copy number/ml, IU/ml or any unit of concentration of interest.<br>
Second column is number of reps at each dilution<br>
Third column is number of positive reps at each dilution<br>
The range of concentration is 0.1 to 60000. If you data is not in this range, scale it to this range.
tab or space delimited; no header please<br>
<br>
<PRE  style="display: inline-block; border:2px dashed Blue;"> 
10.0	25	25
5.0	25	15
2.5	25	5
1.25	25	1
0.625	25	0

</PRE> 
<br>
<!-- Please use exact example format <br>
 <input type="text" name="cases">cases (no comma) e.g. 1000<br>
-->
Paste input data: <br>
 <TEXTAREA name="query" rows="10" cols="80"></TEXTAREA><br>
<br>

<input type="submit" name = "submit" value="RUN" style="background-color:lightgreen">

</form> 
</body>
</html>