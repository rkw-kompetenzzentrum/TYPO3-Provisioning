--
-- Date: 20190123
-- Version: 1.0.3
--

--
-- Rewrite Domains
--
UPDATE `sys_domain`  SET `domainName` = replace(domainName, '.de', '.rkw.codes');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, '.eu', '.rkw.codes');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, 'www.', '');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, 'rkw.rkw.', 'rkw.');
UPDATE `sys_domain`  SET `domainName` = replace(domainName, '.rkw-kompetenzzentrum.rkw.', '.rkw.');
