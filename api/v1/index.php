<?php
class DB{
	static private$_db = null;
	static function dbx(){
		if(self::$_db){
			return self::$_db;
		} else {
			self::$_db = new PDO('mysql:dbname=flapp;host=127.0.0.1;charset=utf8', 'root', '');
			self::$_db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
			self::$_db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);	
			return self::$_db;			
		}
	}
}
require 'flight/Flight.php';


Flight::route('GET /', function(){
    echo json_encode(['status'=>200, 'name'=>'Flapp API', 'version'=>0.1]);
});

Flight::route('GET /foods', function(){
    $foods=DB::dbx()->query('SELECT name AS name, tcase(name) AS display FROM food ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
	echo json_encode(['status'=>200, 'payload'=>$foods]);
});

Flight::route('GET /modifiers', function(){
    $mods=DB::dbx()->query('SELECT name AS name, tcase(name) AS display FROM modifier ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
	echo json_encode(['status'=>200, 'payload'=>$mods]);
});

Flight::start();
?>
