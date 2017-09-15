CREATE TABLE `tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255),
  `global` bool,
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

INSERT INTO `tags` VALUES (0, 'image reconstruction', 1);
INSERT INTO `tags` VALUES (0, 'image enhancement', 1);
INSERT INTO `tags` VALUES (0, 'image segmentation', 1);
INSERT INTO `tags` VALUES (0, 'image deblurring', 1);
INSERT INTO `tags` VALUES (0, 'image registration', 1);
INSERT INTO `tags` VALUES (0, 'image compression', 1);
INSERT INTO `tags` VALUES (0, 'image representation', 1);
INSERT INTO `tags` VALUES (0, 'computed tomography', 1);
INSERT INTO `tags` VALUES (0, 'machine learning', 1);
INSERT INTO `tags` VALUES (0, 'deep learning', 1);
INSERT INTO `tags` VALUES (0, 'nonlinear optimization', 1);
INSERT INTO `tags` VALUES (0, 'numerical linear algebra', 1);
INSERT INTO `tags` VALUES (0, 'integral equations for image analysis', 1);
INSERT INTO `tags` VALUES (0, 'partial differential equation models', 1);
INSERT INTO `tags` VALUES (0, 'bayesian methods', 1);
INSERT INTO `tags` VALUES (0, 'statistical inverse estimation methods', 1);
INSERT INTO `tags` VALUES (0, 'inverse problems', 1);
INSERT INTO `tags` VALUES (0, 'computer graphics', 1);
INSERT INTO `tags` VALUES (0, 'computer vision', 1);
INSERT INTO `tags` VALUES (0, 'stochastic processes', 1);


