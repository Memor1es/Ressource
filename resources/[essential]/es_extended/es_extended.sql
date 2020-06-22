USE `essentialmode`;

ALTER TABLE `users`
	ADD COLUMN `name` VARCHAR(50) NULL DEFAULT '' AFTER `money`,
	ADD COLUMN `skin` LONGTEXT NULL AFTER `name`,
	ADD COLUMN `job` varchar(50) NULL DEFAULT 'unemployed' AFTER `skin`,
	ADD COLUMN `job_grade` INT NULL DEFAULT 0 AFTER `job`,
	ADD COLUMN `faction` varchar(50) NULL DEFAULT 'resid' AFTER `job_grade`,
	ADD COLUMN `faction_grade` INT NULL DEFAULT 0 AFTER `faction`,
	ADD COLUMN `loadout` LONGTEXT NULL AFTER `job_grade`,
	ADD COLUMN `position` VARCHAR(36) NULL AFTER `loadout`
;

CREATE TABLE `items` (
	`name` varchar(50) NOT NULL,
	`label` varchar(50) NOT NULL,
	`limit` int(11) NOT NULL DEFAULT '-1',
	`rare` int(11) NOT NULL DEFAULT '0',
	`can_remove` int(11) NOT NULL DEFAULT '1',

	PRIMARY KEY (`name`)
);

CREATE TABLE `job_grades` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`job_name` varchar(50) DEFAULT NULL,
	`grade` int(11) NOT NULL,
	`name` varchar(50) NOT NULL,
	`label` varchar(50) NOT NULL,
	`salary` int(11) NOT NULL,
	`skin_male` longtext NOT NULL,
	`skin_female` longtext NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `job_grades` VALUES (1,'unemployed',0,'unemployed','Unemployed',200,'{}','{}');

CREATE TABLE `jobs` (
	`name` varchar(50) NOT NULL,
	`label` varchar(50) DEFAULT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `jobs` VALUES ('unemployed','Unemployed');


CREATE TABLE `faction_grades` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`faction_name` varchar(50) DEFAULT NULL,
	`grade` int(11) NOT NULL,
	`name` varchar(50) NOT NULL,
	`label` varchar(50) NOT NULL,
	`salary` int(11) NOT NULL,
	`skin_male` longtext NOT NULL,
	`skin_female` longtext NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `faction_grades` VALUES (1,'resid',0,'resid','Civil',0,'{}','{}');

CREATE TABLE `factions` (
	`name` varchar(50) NOT NULL,
	`label` varchar(50) DEFAULT NULL,

	PRIMARY KEY (`name`)
);

INSERT INTO `factions` VALUES ('resid','Civil');

CREATE TABLE `user_accounts` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`identifier` varchar(22) NOT NULL,
	`name` varchar(50) NOT NULL,
	`money` double NOT NULL DEFAULT '0',

	PRIMARY KEY (`id`)
);

CREATE TABLE `user_inventory` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`identifier` varchar(22) NOT NULL,
	`item` varchar(50) NOT NULL,
	`count` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);
