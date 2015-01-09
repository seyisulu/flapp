-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.6.17 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             8.3.0.4805
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table flapp.combination
CREATE TABLE IF NOT EXISTS `combination` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `count` int(10) unsigned NOT NULL DEFAULT '0',
  `combo` char(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `combo` (`combo`),
  KEY `count` (`count`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Dumping data for table flapp.combination: ~1 rows (approximately)
/*!40000 ALTER TABLE `combination` DISABLE KEYS */;
REPLACE INTO `combination` (`id`, `count`, `combo`) VALUES
	(1, 1, '16:62,9:1'),
	(5, 2, '16:62,9:58');
/*!40000 ALTER TABLE `combination` ENABLE KEYS */;


-- Dumping structure for table flapp.combination_option
CREATE TABLE IF NOT EXISTS `combination_option` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `combination_id` int(10) unsigned NOT NULL,
  `food_id` int(10) unsigned NOT NULL,
  `modifier_id` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `FK_combination_option_combination` (`combination_id`),
  KEY `FK_combination_option_food` (`food_id`),
  KEY `FK_combination_option_modifier` (`modifier_id`),
  CONSTRAINT `FK_combination_option_combination` FOREIGN KEY (`combination_id`) REFERENCES `combination` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_combination_option_food` FOREIGN KEY (`food_id`) REFERENCES `food` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_combination_option_modifier` FOREIGN KEY (`modifier_id`) REFERENCES `modifier` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table flapp.combination_option: ~2 rows (approximately)
/*!40000 ALTER TABLE `combination_option` DISABLE KEYS */;
REPLACE INTO `combination_option` (`id`, `combination_id`, `food_id`, `modifier_id`) VALUES
	(1, 1, 1, 9),
	(2, 1, 62, 16),
	(3, 5, 62, 16),
	(4, 5, 58, 9);
/*!40000 ALTER TABLE `combination_option` ENABLE KEYS */;


-- Dumping structure for view flapp.combo
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `combo` (
	`id` INT(10) UNSIGNED NOT NULL,
	`foods` VARCHAR(341) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for view flapp.combo_option
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `combo_option` (
	`id` INT(10) UNSIGNED NOT NULL,
	`combo_id` INT(10) UNSIGNED NOT NULL,
	`modifier` VARCHAR(128) NULL COLLATE 'utf8_general_ci',
	`name` VARCHAR(128) NULL COLLATE 'utf8_general_ci',
	`food` VARCHAR(257) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for table flapp.food
CREATE TABLE IF NOT EXISTS `food` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8;

-- Dumping data for table flapp.food: ~58 rows (approximately)
/*!40000 ALTER TABLE `food` DISABLE KEYS */;
REPLACE INTO `food` (`id`, `name`) VALUES
	(1, 'beans'),
	(2, 'garri'),
	(3, 'flour'),
	(4, 'fruits'),
	(5, 'plantain'),
	(6, 'potato'),
	(7, 'yam'),
	(8, 'beverages'),
	(9, 'juice'),
	(10, 'milk'),
	(11, 'groundnut'),
	(12, 'butter'),
	(13, 'jam'),
	(14, 'bread '),
	(15, 'cornflakes '),
	(16, 'groundnut oil'),
	(17, 'oil'),
	(18, 'pepper'),
	(19, 'onion'),
	(20, 'seasoning'),
	(21, 'egg'),
	(22, 'spaghetti'),
	(23, 'semovita '),
	(24, 'indomie'),
	(25, 'tomato paste'),
	(26, 'golden morn '),
	(27, 'wheat'),
	(28, 'yam flour'),
	(29, 'sugar'),
	(31, 'quaker oats'),
	(32, 'custard'),
	(33, 'sardine'),
	(34, 'corned beef'),
	(35, 'tuna fish'),
	(36, 'sweet potatoes'),
	(37, 'pancakes'),
	(38, 'french toast'),
	(39, 'akara'),
	(40, 'cereals'),
	(41, 'corn'),
	(42, 'pasta'),
	(44, 'yogurt'),
	(45, 'fish'),
	(47, 'shrimps'),
	(49, 'cake'),
	(50, 'doughnut'),
	(51, 'chin chin'),
	(52, 'cookies'),
	(53, 'pap'),
	(54, 'vegetables'),
	(55, 'suya'),
	(56, 'burger'),
	(57, 'chocolate'),
	(58, 'chicken'),
	(59, 'pizza'),
	(60, 'honey'),
	(61, 'cheese'),
	(62, 'rice');
/*!40000 ALTER TABLE `food` ENABLE KEYS */;


-- Dumping structure for table flapp.modifier
CREATE TABLE IF NOT EXISTS `modifier` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- Dumping data for table flapp.modifier: ~10 rows (approximately)
/*!40000 ALTER TABLE `modifier` DISABLE KEYS */;
REPLACE INTO `modifier` (`id`, `name`) VALUES
	(1, ' '),
	(8, 'fried'),
	(9, 'baked'),
	(10, 'roasted'),
	(11, 'sauteed'),
	(12, 'grilled'),
	(13, 'mashed'),
	(14, 'pounded'),
	(15, 'boiled'),
	(16, 'jollof');
/*!40000 ALTER TABLE `modifier` ENABLE KEYS */;


-- Dumping structure for function flapp.replaceword
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `replaceword`( str VARCHAR(128), word VARCHAR(128) ) RETURNS varchar(128) CHARSET utf8
BEGIN
  DECLARE loc INT;
  DECLARE punct CHAR(27) DEFAULT ' ()[]{},.-_!@;:?/''"#$%^&*<>'; 
  DECLARE lowerWord VARCHAR(128);
  DECLARE lowerStr VARCHAR(128);

  IF LENGTH(word) = 0 THEN
    RETURN str;
  END IF;
  SET lowerWord = LOWER(word);
  SET lowerStr = LOWER(str);
  SET loc = LOCATE(lowerWord, lowerStr, 1);
  WHILE loc > 0 DO
    IF loc = 1 OR LOCATE(SUBSTRING(str, loc-1, 1), punct) > 0 THEN
      IF loc+LENGTH(word) > LENGTH(str) OR LOCATE(SUBSTRING(str, loc+LENGTH(word), 1), punct) > 0 THEN
        SET str = INSERT(str,loc,LENGTH(word),word);
      END IF;
    END IF;
    SET loc = LOCATE(lowerWord, lowerStr, loc+LENGTH(word));
  END WHILE;
  RETURN str;
END//
DELIMITER ;


-- Dumping structure for function flapp.tcase
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `tcase`( str VARCHAR(128) ) RETURNS varchar(128) CHARSET utf8
BEGIN 
  DECLARE c CHAR(1); 
  DECLARE s VARCHAR(128); 
  DECLARE i INT DEFAULT 1; 
  DECLARE bool INT DEFAULT 1; 
  DECLARE punct CHAR(27) DEFAULT ' ()[]{},.-_!@;:?/''"#$%^&*<>'; 

  SET s = LCASE( str ); 
  WHILE i <= LENGTH( str ) DO
    BEGIN 
      SET c = SUBSTRING( s, i, 1 ); 
      IF LOCATE( c, punct ) > 0 THEN 
        SET bool = 1; 
      ELSEIF bool=1 THEN  
        BEGIN 
          IF c >= 'a' AND c <= 'z' THEN  
            BEGIN 
              SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1)); 
              SET bool = 0; 
            END; 
          ELSEIF c >= '0' AND c <= '9' THEN 
            SET bool = 0; 
          END IF; 
        END; 
      END IF; 
      SET i = i+1; 
    END; 
  END WHILE;

  SET s = replaceword(s, 'a');
  SET s = replaceword(s, 'an');
  SET s = replaceword(s, 'and');
  SET s = replaceword(s, 'as');
  SET s = replaceword(s, 'at');
  SET s = replaceword(s, 'but');
  SET s = replaceword(s, 'by');
  SET s = replaceword(s, 'for');
  SET s = replaceword(s, 'if');
  SET s = replaceword(s, 'in');
  SET s = replaceword(s, 'n');
  SET s = replaceword(s, 'of');
  SET s = replaceword(s, 'on');
  SET s = replaceword(s, 'or');
  SET s = replaceword(s, 'the');
  SET s = replaceword(s, 'to');
  SET s = replaceword(s, 'via');

  SET s = replaceword(s, 'RSS');
  SET s = replaceword(s, 'URL');
  SET s = replaceword(s, 'PHP');
  SET s = replaceword(s, 'SQL');
  SET s = replaceword(s, 'OPML');
  SET s = replaceword(s, 'DHTML');
  SET s = replaceword(s, 'CSV');
  SET s = replaceword(s, 'iCal');
  SET s = replaceword(s, 'XML');
  SET s = replaceword(s, 'PDF');

  SET c = SUBSTRING( s, 1, 1 ); 
  IF c >= 'a' AND c <= 'z' THEN  
      SET s = CONCAT(UCASE(c),SUBSTRING(s,2)); 
  END IF; 

  RETURN s; 
END//
DELIMITER ;


-- Dumping structure for view flapp.combo
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `combo`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `combo` AS SELECT combo_id as id, TRIM(GROUP_CONCAT(' ', food)) as 'foods' FROM combo_option
GROUP BY combo_id ;


-- Dumping structure for view flapp.combo_option
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `combo_option`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `combo_option` AS SELECT co.id, co.combination_id as 'combo_id', tcase(m.name) as 'modifier', tcase(f.name) as 'name', TRIM(CONCAT_WS(' ', tcase(m.name), tcase(f.name))) as 'food' FROM combination_option co
JOIN food f on f.id = co.food_id
JOIN modifier m on m.id = co.modifier_id ;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
