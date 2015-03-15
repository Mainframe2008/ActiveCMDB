CREATE TABLE config_rule (
	rule_id			INTEGER NOT NULL AUTO_INCREMENT,
	name			VARCHAR(128) NOT NULL,
	active			TINYINT NOT NULL DEFAULT '0', 
	set_id			INTEGER NOT NULL DEFAULT '0',
	regex_start		VARCHAR(255) NOT NULL,
	regex_end		VARCHAR(255) NOT NULL,
	os_version		VARCHAR(128) NOT NULL,
	last_update		BIGINT NOT NULL DEFAULT '0',
	updated_by		VARCHAR(32) NOT NULL,
	description		TEXT,
	PRIMARY KEY (rule_id),
	INDEX (name),
	CONSTRAINT FK_CMDB003 FOREIGN KEY (set_id) REFERENCES config_ruleset (set_id) ON DELETE RESTRICT ON UPDATE RESTRICT 
) Engine=InnoDB DEFAULT CHARSET=utf8;