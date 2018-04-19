<html>
<head>
<title>WG-SERVER</title>
<style>
body {
margin-left: 100px;
margin-top: 25px;
font-family: "Open Sans Condensed Light",sans-serif;
font-size: 13px;
}
h1 {
font-weight: bold;
font-size: 16px;
}
h2 {
font-weight: bold;
font-size: 13px;
display: inline;
}
</style>
</head>
<body>
<?php
$file = 'mdstat.txt';
$mdstat = file_get_contents ($file);
$file = 'diskfree-root.csv';
$diskfreeroot = file_get_contents ($file);
$file = 'diskfree-storage.csv';
$diskfreestorage = file_get_contents ($file);
$file='timestamp.txt';
$lastupdate = file_get_contents ($file);
?>

<h1>//WG-SERVER</h1>
<style type="text/css">
#overall-status
 {
 width: 25px;
 border: 2px solid black;
 position: relative;
 padding: 1px;
 float: left;
 margin-right: 10px;
 margin-top: -3px;
}

#color-stat {
 height: 60px;
 background-color: #<?php
 $uppos = strpos($mdstat, 'algorithm 2');
  if ((substr($mdstat, $uppos + 19, 1) == 'U') && (substr($mdstat, $uppos + 20, 1) == 'U') && (substr($mdstat, $uppos + 21, 1) == 'U')) {
	echo '2CB299';
} else {
	echo 'E44C41';
}
 ?>;
 width: 100%;
}
</style>
<div id="overall-status">
    <div id="color-stat"></div>
</div>
<h2>Systemzeit: </h2>
<?php
$timestamp = time();
$datum = date("d.m.Y",$timestamp);
$uhrzeit = date("H:i",$timestamp);
echo $datum,", ",$uhrzeit," Uhr";
?><br/>

<h2>Uptime: </h2>
<?php
$uptime = shell_exec("cut -d. -f1 /proc/uptime");
$days = floor($uptime/60/60/24);
$hours = $uptime/60/60%24;
$mins = $uptime/60%60;
$secs = $uptime%60;
echo "$days Tage, $hours Stunden, $mins Minuten";
?><br/><br/>

<h2>Letztes Update: </h2>
<?php
echo $lastupdate;
?><br/><br/><br/><br/>

<h1>RAID</h1>
<h2>RAID Level: </h2><?php
$levelpos = strpos($mdstat, 'level ');
if ($levelpos === false) {
	echo 'n/a';
} else {
	echo substr($mdstat, $levelpos + 6, 1);
}
?><br/>

<h2>Status: </h2><?php
if (strpos($mdstat, 'active') !== FALSE){
    echo 'aktiv';
} else {
    echo 'inaktiv';
}
?><br/>

<h2>Ger&aumlte: </h2><?php
$devicepos = strpos($mdstat, '5 ');
if ($devicepos === false) {
	echo 'n/a';
} else {
	echo substr($mdstat, $devicepos + 2, ( strpos($mdstat, PHP_EOL, $devicepos) ) - $devicepos);
}
?><br/><br/>

<h2>ben&oumltigte Ger&aumlte/laufende Ger&aumlte: </h2><?php
$inusepos = strpos($mdstat, '2 [');
if ($inusepos === false) {
	echo 'n/a';
} else {
	echo substr($mdstat, $inusepos + 3, 3);
}
?><br/>

<h2>Ger&aumlt 0: </h2><?php
$uppos = strpos($mdstat, 'algorithm 2');
if (substr($mdstat, $uppos + 19, 1) === 'U') {
	echo 'online';
} else {
	echo 'offline';
}
?><br/>

<h2>Ger&aumlt 1: </h2><?php
$uppos = strpos($mdstat, 'algorithm 2');
if (substr($mdstat, $uppos + 20, 1) === 'U') {
	echo 'online';
} else {
	echo 'offline';
}
?><br/>

<h2>Ger&aumlt 2: </h2><?php
$uppos = strpos($mdstat, 'algorithm 2');
if (substr($mdstat, $uppos + 21, 1) === 'U') {
	echo 'online';
} else {
	echo 'offline';
}
?><br/>
<br/><br/><br/>

<h1>DATEISYSTEME</h1>
<h1>md0</h1>
<h2>Kapazit&aumlt: </h2><?php
$arr_storage = str_getcsv ($diskfreestorage, ',');
echo $arr_storage[8];
?><br/>

<h2>Belegt: </h2><?php
echo $arr_storage[9];
?><br/>

<h2>Verf&uumlgbar: </h2><?php
echo $arr_storage[10];
?><br/><br/>
<style type="text/css">
#capacity-utilization
 {
 width: 500px;
 border: 2px solid black;
 position: relative;
 padding: 1px;
}

#percent {
 position: absolute;
 left: 50%;
 font-weight: bold;
}

#bar-storage {
 height: 20px;
 background-color: #38B1CC;
 width: <?php
		echo $arr_storage[11];
	?>;
}
</style>

<div id="capacity-utilization">
    <span id="percent"><?php
		echo $arr_storage[11];
	?></span>
    <div id="bar-storage"></div>
</div>
<br/><br/>

<h1>root</h1>
<h2>Kapazit&aumlt: </h2><?php
$arr_root = str_getcsv ($diskfreeroot, ',');
echo $arr_root[8];
?><br/>

<h2>Belegt: </h2><?php
echo $arr_root[9];
?><br/>

<h2>Verf&uumlgbar: </h2><?php
echo $arr_root[10];
?><br/><br/>
<style type="text/css">
#capacity-utilization-storage
 {
 width: 500px;
 border: 2px solid black;
 position: relative;
 padding: 1px;
}

#bar-root {
 height: 20px;
 background-color: #38B1CC;
 width: <?php
		echo $arr_root[11];
	?>;
}
</style>

<div id="capacity-utilization-storage">
    <span id="percent"><?php
		echo $arr_root[11];
	?></span>
    <div id="bar-root"></div>
</div>
<br/><br/>
</body>
</html>
