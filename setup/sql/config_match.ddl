CREATE TABLE config_match (
	match_id		INTEGER NOT NULL AUTO_INCREMENT,
	rule_id			INTEGER NOT NULL,
	line_match		VARCHAR(255) NOT NULL,
	reverse			TINYINT NOT NULL DEFAULT '0',
	last_update		BIGINT NOT NULL DEFAULT '0',
	updated_by		VARCHAR(32) NOT NULL,
	PRIMARY KEY(match_id),
	CONSTRAINT FK_CMDB004 FOREIGN KEY (rule_id) REFERENCES config_rule (rule_id) ON DELETE CASCADE ON UPDATE CASCADE
) Engine=InnoDB DEFAULT CHARSET=utf8;
