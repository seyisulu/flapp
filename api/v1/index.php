<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST' && empty($_POST))
    $_POST = (array) json_decode(file_get_contents('php://input'), true);
class X{
	private static function is_valid_callback($subject)
	{
	     $identifier_syntax
	       = '/^[$_\p{L}][$_\p{L}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\x{200C}\x{200D}]*+$/u';
	
	     $reserved_words = ['break', 'do', 'instanceof', 'typeof', 'case',
	       'else', 'new', 'var', 'catch', 'finally', 'return', 'void', 'continue', 
	       'for', 'switch', 'while', 'debugger', 'function', 'this', 'with', 
	       'default', 'if', 'throw', 'delete', 'in', 'try', 'class', 'enum', 
	       'extends', 'super', 'const', 'export', 'import', 'implements', 'let', 
	       'private', 'public', 'yield', 'interface', 'package', 'protected', 
	       'static', 'null', 'true', 'false'];
	
	     return preg_match($identifier_syntax, $subject)
	         && ! in_array(mb_strtolower($subject, 'UTF-8'), $reserved_words);
	}
	static function respond($data) {
		header("access-control-allow-origin: *");
		if( ! isset($_GET['callback'])) {
			header('Content-Type: application/json; charset=utf-8');
		    Flight::json($data);			
		} elseif(self::is_valid_callback($_GET['callback'])) {
			header('Content-Type: application/javascript; charset=utf-8');
		    //Flight::jsonp($data, 'callback');
		    echo sprintf("%s(%s)", $_GET['callback'], json_encode($data));
		} else {
			header('HTTP/1.1 400 Bad Request');
		}
	}
	static function r($data) {
		self::respond($data);
	}
}
require 'flight/Flight.php';

Flight::register('db', 'PDO', array('mysql:dbname=flapp;host=127.0.0.1;charset=utf8','root',''), function($db){
	$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
	$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
});

Flight::route('GET /', function(){
    X::r(['status'=>200, 'name'=>'Flapp API', 'version'=>1.0]);
});

#Food API

Flight::route('GET /food', function(){
    $foods=Flight::db()->query('SELECT id, name FROM food ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
	X::r($foods);
});

Flight::route('POST /food', function(){
	if(isset($_POST['name'])){
		try {#TODO: remove extra spaces between multiword food names; check for existing foods 
			$name=strtolower(trim($_POST['name']));
		    $stmt=Flight::db()->prepare('INSERT INTO food (name) VALUES (:name)');
			$stmt->execute([':name'=>$name]);
			X::r(['id'=>Flight::db()->lastInsertId(),'name'=>$name]);			
		} catch(Exception $e) {
			X::r(['id'=>0]);
		}		
	}else{
		X::r(['id'=>0]);
	}	
});

Flight::route('GET /food/@id:[0-9]+', function($id){
    $stmt=Flight::db()->prepare('SELECT id, name FROM food WHERE id=:id');
	$stmt->execute([':id'=>$id]);
	$food=$stmt->fetch(PDO::FETCH_ASSOC);
	$food?X::r($food):X::r(['id'=>0]);
});

#Modifier API

Flight::route('GET /mod', function(){
    $mods=Flight::db()->query('SELECT id, name FROM modifier ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
	X::r($mods);
});

Flight::route('POST /mod', function(){
	if(isset($_POST['name'])){
		try { 
			$name=strtolower(trim($_POST['name']));
		    $stmt=Flight::db()->prepare('INSERT INTO modifier (name) VALUES (:name)');
			$stmt->execute([':name'=>$name]);
			X::r(['id'=>Flight::db()->lastInsertId(),'name'=>$name]);			
		} catch(Exception $e) {
			X::r(['id'=>0,'err'=>$e->getMessage()]);
		}		
	}else{
		X::r(['id'=>0]);
	}	
});

Flight::route('GET /mod/@id:[0-9]+', function($id){
    $stmt=Flight::db()->prepare('SELECT id, name FROM modifier WHERE id=:id');
	$stmt->execute([':id'=>$id]);
	$modx=$stmt->fetch(PDO::FETCH_ASSOC);
	$modx?X::r($modx):X::r(['id'=>0]);
});

#Combination API

Flight::route('GET /combo', function(){    
    $cmbs=Flight::db()->query('SELECT id, name FROM combo ORDER BY id')->fetchAll(PDO::FETCH_ASSOC);
	X::r($cmbs);
});

Flight::route('POST /combo', function(){
	if(isset($_POST['fids']) && isset($_POST['mids'])){
		try { 
			$fids = array_map('intval', $_POST['fids']);//Prevent SQL injection vector
			$mids = array_map('intval', $_POST['mids']);
			Flight::db()->beginTransaction();#Note to future self - fid1:mid1,fid2:mid2
			$rslt = Flight::db()->prepare('INSERT INTO combination (count) VALUES (:count)')->execute([':count'=>1]);
			$lstd = Flight::db()->lastInsertId();
			$cmb2 = function($m,$f) use($lstd) {return sprintf('(%d,%d,%d)',$lstd,$f,$m);};
			$cmbc = array_map($cmb2,$mids,$fids);
			$cmbd = join(',',$cmbc);
			$rsl2 = Flight::db()->exec(sprintf('INSERT INTO combination_option (combination_id,food_id,modifier_id) VALUES %s',$cmbd));
			Flight::db()->commit();
			$stmt=Flight::db()->prepare('SELECT id, name FROM combo WHERE id=:id');
			$stmt->execute([':id'=>$lstd]);
			X::r($stmt->fetch(PDO::FETCH_ASSOC));			
		} catch(Exception $e) {
			Flight::db()->rollBack();
			X::r(['id'=>0]);
		}		
	}else{
		X::r(['id'=>0]);
	}	
});

Flight::route('GET /combo/@id:[0-9]+', function($id){
	if(isset($_GET['food']) && $_GET['food']=='food') {		
	    $stmt=Flight::db()->prepare('SELECT id, combo_id, mdx, food, name FROM combo_option WHERE combo_id=:id');
		$stmt->execute([':id'=>$id]);
		$cfdx=$stmt->fetchAll(PDO::FETCH_ASSOC);
		$cfdx?X::r($cfdx):X::r([]);
	} else {
		$stmt=Flight::db()->prepare('SELECT id, name FROM combo WHERE id=:id');
		$stmt->execute([':id'=>$id]);
		$cmbo=$stmt->fetch(PDO::FETCH_ASSOC);
		$cmbo?X::r($cmbo):X::r(['id'=>0]);
	}    
});

Flight::route('GET /combo/@id:[0-9]+/food', function($id){
    $stmt=Flight::db()->prepare('SELECT id, combo_id, mdx, food, name FROM combo_option WHERE combo_id=:id');
	$stmt->execute([':id'=>$id]);
	$cfdx=$stmt->fetchAll(PDO::FETCH_ASSOC);
	$cfdx?X::r($cfdx):X::r([]);
});

#Retrieve All

Flight::route('GET /start', function(){	
    $foods=Flight::db()->query('SELECT id, name FROM food ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    $mods=Flight::db()->query('SELECT id, name FROM modifier ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    $cmbs=Flight::db()->query('SELECT id, name FROM combo ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
	X::r(['status'=>200, 'payload'=>['foods'=>$foods,'mods'=>$mods,'combos'=>$cmbs]]);
});

Flight::start();
?>
