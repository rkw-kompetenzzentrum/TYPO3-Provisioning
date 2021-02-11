--
-- Date: 2021-02-11
-- Version: 1.0.4
--

--
-- Rewrite Domains
--
UPDATE `sys_domain`  SET `domainName` = replace(domainName, '.de', '.rkw.codes');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, '.eu', '.rkw.codes');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, '.events', '.rkw.codes');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, 'www.', '');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, 'rkw.rkw.', 'rkw.');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, '.rkw-kompetenzzentrum.rkw.', '.rkw.');
