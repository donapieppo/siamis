CREATE TABLE `tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255),
  PRIMARY KEY (`id`),
  KEY `name` (`name`)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `taggins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(10) unsigned NOT NULL,
  `presentation_id` int(10) unsigned,
  `conference_session_id` int(10) unsigned,
  PRIMARY KEY (`id`),
  KEY `tag_id` (`tag_id`),
  KEY `presentation_id` (`presentation_id`),
  KEY `conference_session_id` (`conference_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `tags` VALUES (0, 'reconstruction');
INSERT INTO `tags` VALUES (0, 'enhancement');
INSERT INTO `tags` VALUES (0, 'segmentation');
INSERT INTO `tags` VALUES (0, 'analysis');
INSERT INTO `tags` VALUES (0, 'registration');
INSERT INTO `tags` VALUES (0, 'compression');
INSERT INTO `tags` VALUES (0, 'representation');
INSERT INTO `tags` VALUES (0, 'tomography');
INSERT INTO `tags` VALUES (0, 'machine learning');
INSERT INTO `tags` VALUES (0, 'nonlinear optimization');
INSERT INTO `tags` VALUES (0, 'numerical linear algebra');
INSERT INTO `tags` VALUES (0, 'integral equations');
INSERT INTO `tags` VALUES (0, 'partial differential equations');
INSERT INTO `tags` VALUES (0, 'bayesian methods');
INSERT INTO `tags` VALUES (0, 'statistical inverse estimation methods');
INSERT INTO `tags` VALUES (0, 'operator theory');
INSERT INTO `tags` VALUES (0, 'differential geometry');
INSERT INTO `tags` VALUES (0, 'information theory');
INSERT INTO `tags` VALUES (0, 'interpolation and approximation');
INSERT INTO `tags` VALUES (0, 'inverse problems');
INSERT INTO `tags` VALUES (0, 'computer graphics and vision');
INSERT INTO `tags` VALUES (0, 'stochastic processes');
