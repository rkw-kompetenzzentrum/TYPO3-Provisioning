--
-- Date: 2021-02-11
-- Version: 1.0.4
--

--
-- disable all scheduler tasks
--
UPDATE tx_scheduler_task SET disable = 1;

--
-- Consolidate data
--
UPDATE tx_rkwevents_domain_model_event SET reservation = '';
UPDATE tx_rkwetracker_domain_model_report SET last_fetch_tstamp = 0, last_mail_tstamp = 0, fetch_counter = 0, month = 0, quarter = 0, year = 0, last_start_tstamp = 0, last_end_tstamp = 0;

--
-- Insert default backend user (user= admin; password = testtest) and notify about it
--
INSERT INTO `be_users` (`uid`, `pid`, `tstamp`, `username`, `password`, `admin`, `usergroup`, `disable`, `starttime`, `endtime`, `lang`, `email`, `db_mountpoints`, `options`, `crdate`, `cruser_id`, `realName`, `userMods`, `allowed_languages`, `uc`, `file_mountpoints`, `workspace_perms`, `lockToDomain`, `disableIPlock`, `deleted`, `TSconfig`, `lastlogin`, `createdByAction`, `usergroup_cached_list`, `workspace_id`, `workspace_preview`, `file_permissions`, `category_perms`, `description`, `avatar`) VALUES
(1, 0, 1491314932, 'admin', '$P$CVqNksrNvEESUFeHOnaf5coZLKy5nV/', 1, '', 0, 0, 0, '', 'admin', NULL, 0, 1491312818, 0, '', NULL, '', 'a:34:{s:14:"interfaceSetup";s:7:"backend";s:10:"moduleData";a:6:{s:8:"web_list";a:0:{}s:10:"FormEngine";a:2:{i:0;a:3:{s:32:"db2637b3e1a160f7041ec3faabf327a5";a:4:{i:0;s:27:"www.rkw-kompetenzzentrum.de";i:1;a:7:{s:4:"edit";a:1:{s:10:"sys_domain";a:1:{i:3;s:4:"edit";}}s:7:"defVals";N;s:12:"overrideVals";N;s:11:"columnsOnly";N;s:6:"noView";N;s:24:"editRegularContentFromId";N;s:9:"workspace";N;}i:2;s:106:"&edit[sys_domain][3]=edit&defVals=&overrideVals=&columnsOnly=&noView=&editRegularContentFromId=&workspace=";i:3;a:5:{s:5:"table";s:10:"sys_domain";s:3:"uid";s:1:"3";s:3:"pid";s:1:"1";s:3:"cmd";s:4:"edit";s:12:"deleteAccess";b:1;}}s:32:"eb0592ef63bbb70e6325b2e824ff3d70";a:4:{i:0;s:35:"wepstra-app.rkw-kompetenzzentrum.de";i:1;a:7:{s:4:"edit";a:1:{s:10:"sys_domain";a:1:{i:20;s:4:"edit";}}s:7:"defVals";N;s:12:"overrideVals";N;s:11:"columnsOnly";N;s:6:"noView";N;s:24:"editRegularContentFromId";N;s:9:"workspace";N;}i:2;s:107:"&edit[sys_domain][20]=edit&defVals=&overrideVals=&columnsOnly=&noView=&editRegularContentFromId=&workspace=";i:3;a:5:{s:5:"table";s:10:"sys_domain";s:3:"uid";s:2:"20";s:3:"pid";s:4:"2854";s:3:"cmd";s:4:"edit";s:12:"deleteAccess";b:1;}}s:32:"3107b94272a0c3194e2479999dc9d94b";a:4:{i:0;s:5:"admin";i:1;a:7:{s:4:"edit";a:1:{s:8:"be_users";a:1:{i:1;s:4:"edit";}}s:7:"defVals";N;s:12:"overrideVals";N;s:11:"columnsOnly";N;s:6:"noView";N;s:24:"editRegularContentFromId";N;s:9:"workspace";N;}i:2;s:104:"&edit[be_users][1]=edit&defVals=&overrideVals=&columnsOnly=&noView=&editRegularContentFromId=&workspace=";i:3;a:5:{s:5:"table";s:8:"be_users";s:3:"uid";s:1:"1";s:3:"pid";s:1:"0";s:3:"cmd";s:4:"edit";s:12:"deleteAccess";b:1;}}}i:1;s:32:"3107b94272a0c3194e2479999dc9d94b";}s:57:"TYPO3\\CMS\\Backend\\Utility\\BackendUtility::getUpdateSignal";a:0:{}s:6:"web_ts";a:2:{s:8:"function";s:85:"TYPO3\\CMS\\Tstemplate\\Controller\\TypoScriptTemplateInformationModuleFunctionController";s:19:"constant_editor_cat";s:7:"content";}s:10:"web_layout";a:2:{s:8:"function";s:1:"1";s:8:"language";s:1:"0";}s:9:"tx_beuser";s:530:"O:40:"TYPO3\\CMS\\Beuser\\Domain\\Model\\ModuleData":2:{s:9:"\0*\0demand";O:36:"TYPO3\\CMS\\Beuser\\Domain\\Model\\Demand":12:{s:11:"\0*\0userName";s:0:"";s:11:"\0*\0userType";i:0;s:9:"\0*\0status";i:0;s:9:"\0*\0logins";i:0;s:19:"\0*\0backendUserGroup";N;s:6:"\0*\0uid";N;s:16:"\0*\0_localizedUid";N;s:15:"\0*\0_languageUid";N;s:16:"\0*\0_versionedUid";N;s:6:"\0*\0pid";N;s:61:"\0TYPO3\\CMS\\Extbase\\DomainObject\\AbstractDomainObject\0_isClone";b:0;s:69:"\0TYPO3\\CMS\\Extbase\\DomainObject\\AbstractDomainObject\0_cleanProperties";a:0:{}}s:18:"\0*\0compareUserList";a:0:{}}";}s:19:"thumbnailsByDefault";i:1;s:14:"emailMeAtLogin";i:0;s:11:"startModule";s:29:"help_AboutmodulesAboutmodules";s:18:"hideSubmoduleIcons";i:0;s:8:"titleLen";s:2:"50";s:8:"edit_RTE";i:1;s:20:"edit_docModuleUpload";i:1;s:17:"navFrameResizable";i:0;s:15:"resizeTextareas";i:1;s:25:"resizeTextareas_MaxHeight";s:3:"500";s:24:"resizeTextareas_Flexible";i:0;s:4:"lang";s:2:"de";s:19:"firstLoginTimeStamp";i:1491312873;s:15:"moduleSessionID";a:6:{s:8:"web_list";s:32:"493d75fd45f53ff5c76c401c3f55f711";s:10:"FormEngine";s:32:"493d75fd45f53ff5c76c401c3f55f711";s:57:"TYPO3\\CMS\\Backend\\Utility\\BackendUtility::getUpdateSignal";s:32:"493d75fd45f53ff5c76c401c3f55f711";s:6:"web_ts";s:32:"493d75fd45f53ff5c76c401c3f55f711";s:10:"web_layout";s:32:"493d75fd45f53ff5c76c401c3f55f711";s:9:"tx_beuser";s:32:"493d75fd45f53ff5c76c401c3f55f711";}s:17:"BackendComponents";a:1:{s:6:"States";a:1:{s:8:"Pagetree";O:8:"stdClass":1:{s:9:"stateHash";O:8:"stdClass":56:{s:1:"0";i:1;s:1:"1";i:1;s:2:"36";i:1;s:2:"84";i:1;s:2:"85";i:1;s:2:"89";i:1;s:3:"198";i:1;s:3:"199";i:1;s:3:"279";i:1;s:3:"308";i:1;s:3:"558";i:1;s:3:"560";i:1;s:3:"565";i:1;s:3:"772";i:1;s:3:"781";i:1;s:3:"886";i:1;s:4:"root";i:1;s:1:"c";i:1;s:1:"f";i:1;s:1:"e";i:1;s:16:"lastSelectedNode";s:4:"p26a";s:3:"b25";i:1;s:3:"b26";i:1;s:3:"c9d";i:1;s:3:"b28";i:1;s:3:"b3e";i:1;s:3:"b3f";i:1;s:3:"b27";i:1;s:3:"b3c";i:1;s:3:"b3b";i:1;s:3:"b3d";i:1;s:3:"55a";i:1;s:3:"abc";i:1;s:1:"b";i:1;s:3:"c9f";i:1;s:3:"38b";i:1;s:3:"8d6";i:1;s:3:"b0d";i:1;s:3:"17f";i:1;s:3:"27c";i:1;s:3:"83d";i:1;s:3:"a8b";i:1;s:3:"baa";i:1;s:3:"b29";i:1;s:3:"c9e";i:1;s:2:"8b";i:1;s:3:"26a";i:1;s:3:"26b";i:1;s:3:"aa9";i:1;s:3:"2fc";i:1;s:3:"d24";i:1;s:3:"55d";i:1;s:3:"a82";i:1;s:3:"9ec";i:1;s:3:"bdf";i:1;s:3:"9e2";i:1;}}}}s:8:"realName";s:0:"";s:5:"email";s:0:"";s:8:"password";s:0:"";s:9:"password2";s:0:"";s:15:"passwordCurrent";s:0:"";s:6:"avatar";s:0:"";s:25:"showHiddenFilesAndFolders";i:0;s:10:"copyLevels";s:0:"";s:15:"recursiveDelete";i:0;s:18:"resetConfiguration";s:0:"";s:13:"debugInWindow";i:0;s:8:"rteWidth";s:0:"";s:9:"rteHeight";s:0:"";s:9:"rteResize";i:0;s:12:"rteMaxHeight";s:0:"";s:22:"rteCleanPasteBehaviour";s:9:"plainText";s:17:"systeminformation";s:45:"{"system_BelogLog":{"lastAccess":1491314846}}";}', NULL, 1, '', 0, 0, '// enable admin user to clear all system caches without to enter install tool \r\noptions.clearCache.system = 1', 1491312873, 0, NULL, 0, 1, NULL, '', '', 0);

INSERT INTO sys_news (uid, pid, tstamp, crdate, cruser_id, deleted, hidden, starttime, endtime, title, content) VALUES
(1, 0, 1461847399, 1461847399, 1, 0, 0, 0, 0, 'TESTUMGEBUNG', 'Dies ist eine Testumgebung.\r\nLogin mit User <b>admin</b> und Passwort <b>testtest</b>');

-- 
-- Replace files by placeholder
-- 
-- Insert placeholder image
INSERT INTO `sys_file` (extension, mime_type, identifier, name, sha1, identifier_hash, folder_hash, size, creation_date, storage) VALUES('jpg', 'image/jpeg', '/media/image-placeholder.jpg', 'image-placeholder.jpg', '5f00dd740814556cea85f0db83ffc1c061778cdd', 'f0201b2486575f48248d4bd2a8a2117294fe4bdd', '9b0b10211237e189ca11fde3729d3b1a2243ee9c', '1027778', '1533891486', '1');
SET @placeholder_image = last_insert_id();

INSERT INTO `sys_file_metadata` (`file`, `title`, `width`, `height`, `visible`, `status`, `publisher`, `source`, `tx_rkwbasics_publisher`, `tx_rkwbasics_source`, `tx_rkwprojects_project_uid`) VALUES
(@placeholder_image, 'Platzhalter', 2048, 1365, 1, '1', '', '', 'tommasolizzul', 10, 0);
SET @placeholder_image_meta = last_insert_id();

-- Insert placeholder file
INSERT INTO `sys_file` (extension, mime_type, identifier, name, sha1, identifier_hash, folder_hash, size, creation_date, storage) VALUES('pdf', 'application/pdf', '/media/file-placeholder.pdf', 'file-placeholder.pdf', '4ff7b753c45fd7bd70ba18f649a4f6ee711b53ce', '49cb64b7e8a4770deb466a09200b881f127bb7a4', '9b0b10211237e189ca11fde3729d3b1a2243ee9c', '3523621', '1533891486', '1');
SET @placeholder_file = last_insert_id();

-- replace existing references with references to placeholders (images and pdfs)
UPDATE sys_file_reference 
LEFT JOIN sys_file ON (sys_file.uid = sys_file_reference.uid_local)
SET uid_local = @placeholder_image
WHERE sys_file.identifier LIKE "/media%" 
AND sys_file.mime_type LIKE "image/%" 
AND sys_file_reference.table_local = 'sys_file';

UPDATE sys_file_reference 
LEFT JOIN sys_file ON (sys_file.uid = sys_file_reference.uid_local)
SET uid_local = @placeholder_file
WHERE sys_file.identifier LIKE "/media%" 
AND sys_file.mime_type = 'application/pdf'
AND sys_file_reference.table_local = 'sys_file';

-- Delete old files and meta-data in tables
DELETE FROM sys_file WHERE sys_file.identifier LIKE "/media%" 
AND sys_file.mime_type LIKE "image/%" 
AND sys_file.uid != @placeholder_image;

DELETE FROM sys_file WHERE sys_file.identifier LIKE "/media%" 
AND sys_file.mime_type = 'application/pdf' 
AND sys_file.uid != @placeholder_file;

DELETE FROM sys_file_metadata WHERE sys_file_metadata.uid != @placeholder_image_meta;
TRUNCATE sys_file_processedfile;

--
-- Remove security relevant data form TS constants 
--
UPDATE `sys_template` SET `constants` = 'plugin.tx_rkwsoap  {\r\n\r\n  settings {\r\n\r\n    soapServer {\r\n\r\n      # Credentials for client-authentification\r\n      username = \r\n      password = \r\n\r\n      # URL of soap server\r\n      url = https://soap.rkw-kompetenzzentrum.de\r\n\r\n      # List of allowed remote IPs\r\n      allowedRemoteIpList = 195.63.251.130\r\n    }\r\n  }\r\n}\r\n\r\n\r\n#=====================================================================\r\nplugin.tx_rkwgeolocation {\r\n\r\n  settings {\r\n    googleApiKey =\r\n    googleApiKeyJs =\r\n  }\r\n}\r\n\r\n\r\n#=====================================================================\r\nplugin.tx_rkwetracker {\r\n  settings {\r\n    secureCode = 123456\r\n    \r\n    singleSignOnAccountId = \r\n    singleSignOnPassword = \r\n   \r\n    singleSignOnAllowedIps = 127.0.0.1, 195.63.251.130\r\n\r\n  }\r\n}\r\n\r\n\r\n#=====================================================================\r\nplugin.tx_rkwresourcespace_import {\r\n  settings {\r\n    ipRestriction = 127.0.0.1, 195.63.251.130, 195.63.251.131\r\n    resourceSpaceApi {\r\n      baseUrl = https://rkwmedia.rkw.de/api/\r\n      user = \r\n      password = \r\n      privateKey =\r\n    }  \r\n  }\r\n}\r\n' WHERE root = 1;


