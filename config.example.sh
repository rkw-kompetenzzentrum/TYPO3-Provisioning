# ============================================================================
# Configuration
# ============================================================================
declare -r TRUE=0
declare -r FALSE=1
declare -r TMP_DIR="/var/www/[YOUR-DOMAIN]/tmp"

#--------------------------------------------------------------------------
# scripts
declare -r MYSQL="$(which mysql)"
declare -r MYSQLDUMP="$(which mysqldump)"
declare -r AWK="$(which awk)"
declare -r GREP="$(which grep)"

#--------------------------------------------------------------------------
# timestamp and time-format
declare -r TIMESTAMP="timestamp.dat"
declare -r DATE="$(date +%d-%m-%Y)"
declare -r TIME="$(date +%H-%M)"
declare -r START="$(date +%H:%M:%S)"

#--------------------------------------------------------------------------
# path to log-file
declare -r LOGFILE="/var/www/[YOUR-DOMAIN]/log/mysql-provisioner.log"

#--------------------------------------------------------------------------
# Email
declare -r EMAIL="root@vm1.rkw.de"
declare -r SERVER_NAME="vm1.rkw.de"

#--------------------------------------------------------------------------
# Path to store database dumps and place were defaults can be found
declare -r DESTINATION_DIR="/var/www/[YOUR-DOMAIN]/mysql-provisioner/dumps"
declare -r CLEANUP_MYSQL_DIR="/var/www/[YOUR-DOMAIN]/mysql-provisioner/cleanup-mysqls"

#--------------------------------------------------------------------------
# MySQL Setup
declare -r MYSQL_USER_SOURCE="[USER-DUMP-LIVE]"
declare -r MYSQL_PASS_SOURCE="[PASS-DUMP-LIVE]"
declare -r MYSQL_HOST_SOURCE="localhost"
declare -r MYSQL_DATABASE_SOURCE="[DB-LIVE]"

declare -r MYSQL_USER_STAGE="[USER-IMPORT-STAGE]"
declare -r MYSQL_PASS_STAGE="[PASS-IMPORT-STAGE]"
declare -r MYSQL_HOST_STAGE="localhost"
declare -r MYSQL_DATABASE_STAGE="[DB-STAGE]"

declare -r MYSQL_USER_DEV="[USER-IMPORT-DEV]"
declare -r MYSQL_PASS_DEV="[PASS-IMPORT-DEV]"
declare -r MYSQL_HOST_DEV="localhost"
declare -r MYSQL_DATABASE_DEV="[DB-DEV]"

declare -r EXCLUDED_TABLES=(
be_sessions
be_users
cache_md5params
cache_treelist
cf_cache_hash
cf_cache_hash_tags
cf_cache_imagesizes
cf_cache_imagesizes_tags
cf_cache_pages
cf_cache_pagesection
cf_cache_pagesection_tags
cf_cache_pages_tags
cf_cache_rootline
cf_cache_rootline_tags
cf_extbase_datamapfactory_datamap
cf_extbase_datamapfactory_datamap_tags
cf_extbase_reflection
cf_extbase_reflection_tags
cf_pb_social_cache
cf_pb_social_cache_tags
cf_rkw_basics
cf_rkw_basics_tags
cf_rkw_related
cf_rkw_related_tags
cf_rkwrelated_content
cf_rkwrelated_content_tags
cf_rkwrelated_count
cf_rkwrelated_count_tags
cf_rkw_rss
cf_rkw_rss_tags
cf_rkw_tools
cf_rkw_tools_tags
fe_sessions
fe_session_data
fe_users
sys_history
sys_news
sys_log
sys_refindex
tx_realurl_pathdata
tx_realurl_uniqalias
tx_realurl_uniqalias_cache_map
tx_realurl_urldata
tx_rkwalerts_domain_model_alerts
tx_rkwconsultant_domain_model_consultant
tx_rkwconsultant_domain_model_consultantservice
tx_rkwconsultant_domain_model_contactperson
tx_rkwetracker_domain_model_areadata
tx_rkwetracker_domain_model_areasum
tx_rkwetracker_domain_model_downloaddata
tx_rkwetracker_domain_model_downloadsum
tx_rkwetracker_domain_model_reportareasum
tx_rkwetracker_domain_model_reportdownloadsum
tx_rkwevents_domain_model_eventpollanswer
tx_rkwevents_domain_model_eventreservation
tx_rkwevents_domain_model_eventreservationaddperson
tx_rkwfeecalculator_domain_model_supportrequest
tx_rkwfeecalculator_program_consulting_mm
tx_rkwform_domain_model_standardform
tx_rkwmailer_domain_model_bouncemail
tx_rkwmailer_domain_model_link
tx_rkwmailer_domain_model_queuemail
tx_rkwmailer_domain_model_queuerecipient
tx_rkwmailer_domain_model_statisticmail
tx_rkwmailer_domain_model_statisticopening
tx_rkwmailer_domain_model_mailingstatistics
tx_rkwmailer_domain_model_clickstatistics
tx_rkwmailer_domain_model_openingstatistics
tx_rkworder_domain_model_order
tx_rkwregistration_domain_model_registration
tx_rkwregistration_domain_model_service
tx_rkwregistration_domain_model_shippingaddress
tx_rkwregistration_domain_model_privacy
tx_rkwregistration_domain_model_encrypteddata
tx_rkwregistration_domain_model_title
tx_rkwshop_domain_model_order
tx_rkwshop_domain_model_orderitem
tx_rkwsocialcomments_domain_model_comment
tx_rkwsocialcomments_domain_model_report
tx_rkwwatchlist_domain_model_item
tx_rkwwatchlist_domain_model_watchlist
tx_rkwwepstra_domain_model_costsaving
tx_rkwwepstra_domain_model_geographicalsector
tx_rkwwepstra_domain_model_jobfamily
tx_rkwwepstra_domain_model_participant
tx_rkwwepstra_domain_model_performance
tx_rkwwepstra_domain_model_priority
tx_rkwwepstra_domain_model_productivity
tx_rkwwepstra_domain_model_productsector
tx_rkwwepstra_domain_model_reasonwhy
tx_rkwwepstra_domain_model_salestrend
tx_rkwwepstra_domain_model_stepcontrol
tx_rkwwepstra_domain_model_technicaldevelopment
tx_rkwwepstra_domain_model_wepstra
tx_rkwwebcheck_domain_model_questionresult
tx_rkwwebcheck_domain_model_checkresult
tx_rkwwebcheck_domain_model_topicresult
tx_rkwsurvey_domain_model_surveyresult
tx_rkwsurvey_domain_model_questionresult
tx_rkwsurvey_domain_model_token
tx_rkwshop_domain_model_order
tx_rkwshop_domain_model_orderitem
zzz_deleted_cf_rkw_related
zzz_deleted_cf_rkw_related_tags
zzz_deleted_fe_users-bak
zzz_deleted_fe_users-bak2
zzz_deleted_tx_rkwconsultant_domain_model_basicservice
zzz_deleted_tx_rkwconsultant_domain_model_consultant
zzz_deleted_tx_rkwconsultant_domain_model_consultantservice
zzz_deleted_tx_rkwconsultant_domain_model_contactperson
zzz_deleted_tx_rkwconsultant_domain_model_qualification
zzz_deleted_tx_rkwconsultant_domain_model_subservice
zzz_deleted_tx_rkwfeecalculator_domain_model_institution
zzz_deleted_tx_rkwinfolayer_domain_model_infolayer
zzz_deleted_tx_rkwmailer_domain_model_statisticmail
zzz_deleted_tx_rkworder_domain_model_order
zzz_deleted_tx_rkwsearch_domain_model_queueanalysedkeywords
zzz_deleted_tx_rkwsearch_domain_model_queuetaggedcontent
zzz_deleted_tx_rkwsearch_domain_model_ridmapping
zzz_deleted_tx_rkwsocialcomments_domain_model_comment
zzz_deleted_tx_rkwsocialcomments_domain_model_report
zzz_deleted_tx_rkwwatchlist_domain_model_item
zzz_deleted_tx_rkwwatchlist_domain_model_watchlist
)
