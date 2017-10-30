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




