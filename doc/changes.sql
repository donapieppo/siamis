-- ALTER TABLE payments ADD COLUMN `siag`       bool AFTER `amount`;
-- ALTER TABLE payments ADD COLUMN `siam`       bool AFTER `siag`;
-- ALTER TABLE payments ADD COLUMN `student`    bool AFTER `siam`;
-- ALTER TABLE payments ADD COLUMN `single_day` date AFTER `student`;
--
-- ALTER TABLE conference_registrations DROP COLUMN `single_day`;
-- ALTER TABLE conference_registrations ADD COLUMN  `single_day` date AFTER `payment_id`;

ALTER TABLE `conference_sessions` DROP COLUMN `chair_id`;
ALTER TABLE `conference_sessions` DROP COLUMN `start`;

ALTER TABLE `conference_sessions` ADD COLUMN `parts` int(1) DEFAULT 1 AFTER `description`;
ALTER TABLE `presentations`       ADD COLUMN `part` int(1)  DEFAULT 1 AFTER `conference_session_id`;
ALTER TABLE `schedules`           ADD COLUMN `part` int(1)  DEFAULT 1 AFTER `conference_session_id`;

ALTER TABLE `users` ADD COLUMN `student_award` bool DEFAULT 0 AFTER `banquet_tickets`;
UPDATE users set student_award = 1 where id=1038;
UPDATE users set student_award = 1 where id=778;
UPDATE users set student_award = 1 where id=474;
UPDATE users set student_award = 1 where id=267;
UPDATE users set student_award = 1 where id=601;
UPDATE users set student_award = 1 where id=791;
UPDATE users set student_award = 1 where id=1267;
UPDATE users set student_award = 1 where id=583;
UPDATE users set student_award = 1 where id=755;
UPDATE users set student_award = 1 where id=559;
UPDATE users set student_award = 1 where id=426;
UPDATE users set student_award = 1 where id=104;
UPDATE users set student_award = 1 where id=977;


ALTER TABLE `payments` ADD COLUMN `manual` bool DEFAULT 0 AFTER `verified`;

alter table users add column `exhibitor` bool default NULL after `student` ;
alter table interests add column `part` int(1) default NULL after conference_session_id;
update interests set part = 1 where conference_session_id is not null;


alter table conference_sessions change `type` `type` enum('Minisymposium','Minitutorial','Plenary','PosterSession','ContributedSession','PanelSession','ConferenceBreak');


drop table `sightseeings`;
create table `sightseeings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description`  text DEFAULT NULL,
  `starting`     datetime,
  `ending`       datetime,
  `seats`        smallint,
  `webpage`      varchar(255),
  `address`      varchar(255),
  `image_name`   varchar(255),
  `created_at`   datetime,
  `updated_at`   datetime,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into sightseeings values ('1', 
  'Museum "Palazzo Poggi"', 
  'Do you know how scientists used to work in the 18th century? The Museum of Palazzo Poggi recreates the laboratories and collections belonging to the Institute of Sciences and Arts, which was once located in the same building. Here you will learn about the first experimental studies conducted by scientists at the Institute. After almost three centuries, the great frescoed rooms house the famous collections dedicated to geography and nautical science, military architecture, physics, natural history, chemistry, human anatomy and obstetrics, together with the collection belonging to the Aldrovandi Museum.',
  '2018-06-05 12:30',
  '2018-06-05 13:30',
  25,
  'http://www.sma.unibo.it/en/the-university-museum-network/museum-of-palazzo-poggi/museum-of-palazzo-poggi',
  'Via Zamboni, 33 - 40126 Bologna',
  'palazzo_poggi.jpg',
  NOW(),
  NOW()
);
insert into sightseeings values ('2', 
  'Museum "Palazzo Poggi"', 
  'Do you know how scientists used to work in the 18th century? The Museum of Palazzo Poggi recreates the laboratories and collections belonging to the Institute of Sciences and Arts, which was once located in the same building. Here you will learn about the first experimental studies conducted by scientists at the Institute. After almost three centuries, the great frescoed rooms house the famous collections dedicated to geography and nautical science, military architecture, physics, natural history, chemistry, human anatomy and obstetrics, together with the collection belonging to the Aldrovandi Museum.',
  '2018-06-06 12:30',
  '2018-06-06 13:30',
  25,
  'http://www.sma.unibo.it/en/the-university-museum-network/museum-of-palazzo-poggi/museum-of-palazzo-poggi',
  'Via Zamboni, 33 - 40126 Bologna',
  'palazzo_poggi.jpg',
  NOW(),
  NOW()
);
insert into sightseeings values ('3', 
  'Museum "Palazzo Poggi"', 
  'Do you know how scientists used to work in the 18th century? The Museum of Palazzo Poggi recreates the laboratories and collections belonging to the Institute of Sciences and Arts, which was once located in the same building. Here you will learn about the first experimental studies conducted by scientists at the Institute. After almost three centuries, the great frescoed rooms house the famous collections dedicated to geography and nautical science, military architecture, physics, natural history, chemistry, human anatomy and obstetrics, together with the collection belonging to the Aldrovandi Museum.',
  '2018-06-07 12:30',
  '2018-06-07 13:30',
  25,
  'http://www.sma.unibo.it/en/the-university-museum-network/museum-of-palazzo-poggi/museum-of-palazzo-poggi',
  'Via Zamboni, 33 - 40126 Bologna',
  'palazzo_poggi.jpg',
  NOW(),
  NOW()
);

insert into sightseeings values ('4', 
  'Luigi Cattaneo Museum of Wax Anatomical Models', 
  'During the 18th and 19th centuries, medical scientists began to shift their attention from the study of human anatomy to that of pathology, in order to understand the cause and development of certain anomalies. They used wax to make models of the cases studied. At our museum you can see a collection of wax models and preparations which were used to study the human body and its pathologies. Enjoy the precise details of these scientific, historical and artistic treasures.',
  '2018-06-08 09:30',
  '2018-06-08 10:30',
  25,
  'http://www.sma.unibo.it/en/the-university-museum-network/luigi-cattaneo-museum-of-wax-anatomical-models/museo-delle-cere-anatomiche-l-cattaneo-1',
  'Via Irnerio, 48 - 40126 Bologna', 
  'wax_museum.jpeg',
  NOW(),
  NOW()
);
insert into sightseeings values ('5', 
  'Giovanni Capellini Geological Museum', 
  'Do you want to be a geologist for one day and investigate a prehistoric world? Come and see the wonderful collection of the Geological Museum, with over 500 years of didactic activity and scientific research and almost a million exhibits. You will see rocks, plants, fossil invertebrates and vertebrates. Meet some of the ancient creatures that lived on our planet millions of years ago, such as the impressive 26-metre-long Diplodocus, the Mammoth and other spectacular dinosaurs and prehistoric animals.',
  '2018-06-08 09:30',
  '2018-06-08 10:30',
  25,
  'http://www.sma.unibo.it/en/the-university-museum-network/giovanni-capellini-geological-museum-1/giovanni-capellini-geological-museum',
  'via Zamboni, 63 40126 Bologna', 
  'museo_geologico.jpg',
  NOW(),
  NOW()
);

create table `bookings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `sightseeing_id` int(10) unsigned NOT NULL,
  `number` smallint,
  `created_at` datetime,
  `updated_at` datetime,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `sightseeing_id` (`sightseeing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




