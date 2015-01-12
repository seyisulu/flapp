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
  PRIMARY KEY (`id`),
  KEY `count` (`count`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- Dumping data for table flapp.combination: ~3 rows (approximately)
/*!40000 ALTER TABLE `combination` DISABLE KEYS */;
REPLACE INTO `combination` (`id`, `count`) VALUES
	(1, 1),
	(7, 1),
	(8, 1),
	(5, 2);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- Dumping data for table flapp.combination_option: ~9 rows (approximately)
/*!40000 ALTER TABLE `combination_option` DISABLE KEYS */;
REPLACE INTO `combination_option` (`id`, `combination_id`, `food_id`, `modifier_id`) VALUES
	(1, 1, 1, 9),
	(2, 1, 62, 16),
	(3, 5, 62, 16),
	(4, 5, 58, 9),
	(5, 7, 2, 1),
	(7, 7, 29, 1),
	(8, 7, 55, 1),
	(9, 8, 2, 1),
	(10, 8, 29, 1);
/*!40000 ALTER TABLE `combination_option` ENABLE KEYS */;


-- Dumping structure for view flapp.combo
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `combo` (
	`id` INT(10) UNSIGNED NOT NULL,
	`name` VARCHAR(341) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for view flapp.combo_option
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `combo_option` (
	`id` INT(10) UNSIGNED NOT NULL,
	`combo_id` INT(10) UNSIGNED NOT NULL,
	`mdx` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`food` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`name` VARCHAR(101) NOT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;


-- Dumping structure for table flapp.food
CREATE TABLE IF NOT EXISTS `food` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

-- Dumping data for table flapp.food: ~59 rows (approximately)
/*!40000 ALTER TABLE `food` DISABLE KEYS */;
REPLACE INTO `food` (`id`, `name`) VALUES
	(39, 'akara'),
	(1, 'beans'),
	(8, 'beverages'),
	(14, 'bread '),
	(56, 'burger'),
	(12, 'butter'),
	(49, 'cake'),
	(40, 'cereals'),
	(61, 'cheese'),
	(58, 'chicken'),
	(51, 'chin chin'),
	(57, 'chocolate'),
	(52, 'cookies'),
	(41, 'corn'),
	(34, 'corned beef'),
	(15, 'cornflakes '),
	(32, 'custard'),
	(50, 'doughnut'),
	(21, 'egg'),
	(45, 'fish'),
	(3, 'flour'),
	(38, 'french toast'),
	(4, 'fruits'),
	(2, 'garri'),
	(26, 'golden morn '),
	(11, 'groundnut'),
	(16, 'groundnut oil'),
	(60, 'honey'),
	(24, 'indomie'),
	(13, 'jam'),
	(9, 'juice'),
	(63, 'kuli kuli'),
	(10, 'milk'),
	(17, 'oil'),
	(19, 'onion'),
	(37, 'pancakes'),
	(53, 'pap'),
	(42, 'pasta'),
	(18, 'pepper'),
	(59, 'pizza'),
	(5, 'plantain'),
	(6, 'potato'),
	(31, 'quaker oats'),
	(62, 'rice'),
	(33, 'sardine'),
	(20, 'seasoning'),
	(23, 'semovita '),
	(47, 'shrimps'),
	(22, 'spaghetti'),
	(29, 'sugar'),
	(55, 'suya'),
	(36, 'sweet potatoes'),
	(25, 'tomato paste'),
	(35, 'tuna fish'),
	(54, 'vegetables'),
	(27, 'wheat'),
	(7, 'yam'),
	(28, 'yam flour'),
	(44, 'yogurt');
/*!40000 ALTER TABLE `food` ENABLE KEYS */;


-- Dumping structure for table flapp.modifier
CREATE TABLE IF NOT EXISTS `modifier` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- Dumping data for table flapp.modifier: ~10 rows (approximately)
/*!40000 ALTER TABLE `modifier` DISABLE KEYS */;
REPLACE INTO `modifier` (`id`, `name`) VALUES
	(1, ''),
	(9, 'baked'),
	(15, 'boiled'),
	(8, 'fried'),
	(12, 'grilled'),
	(16, 'jollof'),
	(13, 'mashed'),
	(14, 'pounded'),
	(10, 'roasted'),
	(11, 'sauteed'),
	(17, 'stir fried'),
	(18, 'toasted');
/*!40000 ALTER TABLE `modifier` ENABLE KEYS */;


-- Dumping structure for view flapp.combo
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `combo`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `combo` AS SELECT combo_id as id, TRIM(GROUP_CONCAT(' ', name)) as 'name' FROM combo_option
GROUP BY combo_id ;


-- Dumping structure for view flapp.combo_option
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `combo_option`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `combo_option` AS SELECT co.id, co.combination_id as 'combo_id', m.name as 'mdx', f.name as 'food', TRIM(CONCAT_WS(' ', m.name, f.name)) as 'name' FROM combination_option co
JOIN food f on f.id = co.food_id
JOIN modifier m on m.id = co.modifier_id ;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
