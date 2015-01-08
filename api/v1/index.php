<?php
class X{
	static private$_db = null;
	static function db(){
		if(self::$_db){
			return self::$_db;
		} else {
			self::$_db = new PDO('mysql:dbname=flapp;host=127.0.0.1;charset=utf8', 'root', '');
			self::$_db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
			self::$_db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);	
			return self::$_db;			
		}
	}
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
		    echo json_encode($data);			
		} elseif(self::is_valid_callback($_GET['callback'])) {
			header('Content-Type: application/javascript; charset=utf-8');
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


Flight::route('GET /', function(){
    X::r(['status'=>200, 'name'=>'Flapp API', 'version'=>1.0]);
});

Flight::route('GET /foods', function(){
    $foods=X::db()->query('SELECT id, name, tcase(name) AS display FROM food ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
	X::r(['status'=>200, 'payload'=>$foods]);
});

Flight::route('GET /modifiers', function(){
    $mods=X::db()->query('SELECT id, name, tcase(name) AS display FROM modifier ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
	X::r(['status'=>200, 'payload'=>$mods]);
});

Flight::route('GET /combos', function(){
    $cmbs=X::db()->query('SELECT id, count, combo FROM combination ORDER BY id')->fetchAll(PDO::FETCH_ASSOC);
	X::r(['status'=>200, 'payload'=>$mods]);
});

Flight::route('GET /combox', function(){
    $cmbs=X::db()->query('SELECT id, foods FROM combo ORDER BY id')->fetchAll(PDO::FETCH_ASSOC);
	X::r(['status'=>200, 'payload'=>$cmbs]);
});

Flight::route('GET /start', function(){	
    $foods=X::db()->query('SELECT id, name, tcase(name) AS display FROM food ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    $mods=X::db()->query('SELECT id, name, tcase(name) AS display FROM modifier ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    $cmbs=X::db()->query('SELECT id, foods FROM combo ORDER BY id')->fetchAll(PDO::FETCH_ASSOC);
	X::r(['status'=>200, 'payload'=>['foods'=>$foods,'mods'=>$mods,'combos'=>$cmbs]]);
});

Flight::route('POST /combo', function(){
	$fids = array_map('intval', $_POST['fids']);//Prevent SQL injection vector
	$mids = array_map('intval', $_POST['mids']);
	$cmbf = function($mid,$fid){return sprintf('%d:%d',$mid,$fid);};
	$cmba = array_map($cmbf,$mids,$fids);
	$cmbb = join(',',$cmba);
	$rslt = X::db()->prepare('INSERT INTO combination (count,combo) VALUES (:count,:combo) ON DUPLICATE KEY UPDATE count=count+1')->execute([':count'=>1,':combo'=>$cmbb]);
	$lstd = X::db()->lastInsertId();
	$cmb2 = function($m,$f) use($lstd){return sprintf('(%d,%d,%d)',$lstd,$f,$m);};
	$cmbc = array_map($cmb2,$mids,$fids);
	$cmbd = join(',',$cmbc);
	$rsl2 = X::db()->exec(sprintf('INSERT INTO combination_option (combination_id,food_id,modifier_id) VALUES %s',$cmbd));
	X::r(['status'=>200, 'payload'=>$lstd]);
});

Flight::start();
?>
