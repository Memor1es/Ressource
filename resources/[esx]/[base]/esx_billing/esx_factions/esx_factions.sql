INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_ballas', 'Ballas', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_ballas', 'Ballas', 1);

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_ballas', 'Ballas', 1),
	('society_weapons_ballas', 'Weapons Ballas', 1);

INSERT INTO `factions` (`name`, `label`) VALUES
	('ballas', 'Ballas');

INSERT INTO `faction_grades` (`faction_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('ballas', 0, 'recrue', 'Recrue', 0, '{}', '{}'),
	('ballas', 1, 'affranchis', 'Affranchis', 0, '{}', '{}'),
	('ballas', 2, 'boss', 'Boss', 0, '{}', '{}');