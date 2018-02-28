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

