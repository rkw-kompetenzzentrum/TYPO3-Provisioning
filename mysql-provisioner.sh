#!/bin/bash

##############################################################################
# MySQL-Provisioner: Script for MySQL-Provisioning for Staging/Dev
#
# Version: 1.1.1
# Date: 2021/02/10
# Author: Steffen Kroggel <developer@steffenkroggel.de>
##############################################################################

source config.sh

##############################################################################
# Functions
##############################################################################
function check_folder () {

    # check dir
    if [[ -d "$1" ]]; then
        return $TRUE
        #===
    fi

    return $FALSE
    #===
}

# ============================================================================
function check_create_folder () {

    # check dir
    if [[ -d "$1" ]]; then
        return $TRUE
        #===
    fi

    # create dir
    mkdir -p "$1"
    if  [[ "$?" == $TRUE ]]; then
        return $TRUE
        #===
    fi

    echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Can not create folder '${1}'." >> $LOGFILE
    return $FALSE
    #===
}


# ============================================================================
function dump_mysql () {

    local hasError=0
    local type=$1
    local doNotExcludeTables=$2
    local mysqlUser=${MYSQL_USER_SOURCE}
    local mysqlPass=${MYSQL_PASS_SOURCE}
    local mysqlHost=${MYSQL_HOST_SOURCE}
    local mysqlDatabase=${MYSQL_DATABASE_SOURCE}

    if [[ $type == "stage" ]]; then
        mysqlUser=${MYSQL_USER_STAGE}
        mysqlPass=${MYSQL_PASS_STAGE}
        mysqlHost=${MYSQL_HOST_STAGE}
        mysqlDatabase=${MYSQL_DATABASE_STAGE}
    fi

    if [[ $type == "dev" ]]; then
        mysqlUser=${MYSQL_USER_DEV}
        mysqlPass=${MYSQL_PASS_DEV}
        mysqlHost=${MYSQL_HOST_DEV}
        mysqlDatabase=${MYSQL_DATABASE_DEV}
    fi

    echo "Starting MySQL dumping for database '${mysqlDatabase}'..."

    check_folder $TMP_DIR
    if [[ "$?" -gt $TRUE ]]; then
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: TMP_DIR (${TMP_DIR}) does not exist. MySQL-Dump skipped." >> $LOGFILE
        echo "...Failed."
        return $FALSE
        #===
    fi

    # build list of ignored tables
    local ignored_tables_string=''
    if [[ $doNotExcludeTables -ne 1 ]]; then

        echo "Excluding defined tables from data export of database'${mysqlDatabase}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Excluding defined tables from data export of database '${mysqlDatabase}'." >> $LOGFILE

        for table in "${EXCLUDED_TABLES[@]}"
        do :
           ignored_tables_string+=" --ignore-table=${mysqlDatabase}.${table}"
        done
    fi

    #--------------------------------------------------------------------------
    # first we dump the structure
    $MYSQLDUMP -u ${mysqlUser} -h ${mysqlHost} -p${mysqlPass} -d ${mysqlDatabase} 2>&1 > ${TMP_DIR}/${mysqlDatabase}.structure.sql 2>/dev/null
    if  [[ "$?" -gt $TRUE ]]; then
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Error while trying to dump database structure for database '${mysqlDatabase}'." >> $LOGFILE
        hasError=1

    else

        echo "Successfully dumped database structure for '${mysqlDatabase}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully dumped database structure for database '${mysqlDatabase}'." >> $LOGFILE

        #--------------------------------------------------------------------------
        # then we dump the data without structure - except for some tables to ignore
        $MYSQLDUMP -u ${mysqlUser} -h ${mysqlHost} -p${mysqlPass} --no-create-info --skip-triggers ${ignored_tables_string} ${mysqlDatabase} 2>&1 > ${TMP_DIR}/${mysqlDatabase}.data.sql 2>/dev/null
        if  [[ "$?" -gt $TRUE ]]; then
            echo "Error while trying to dump database content for '${mysqlDatabase}'."
            echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Error while trying to dump database content for database '${mysqlDatabase}'." >> $LOGFILE
            hasError=1
        else
            echo "Successfully dumped database content for database '${mysqlDatabase}'."
            echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully dumped database content for database '${mysqlDatabase}'." >> $LOGFILE
        fi
    fi

    echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: MySQL-Dumps for database '${mysqlDatabase}' completed." >> $LOGFILE
    if [[ $hasError -eq 1 ]]; then
        echo "...Failed."
        return $FALSE
        #===
    fi

    echo "...Completed."
    return $TRUE
    #===
}

# ============================================================================
function generate_mysql_files () {

    echo "Starting generation of MySQL-import files..."
    local hasError=0

    check_create_folder $CLEANUP_MYSQL_DIR
    if [[ "$?" -gt $TRUE ]]; then
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: CLEANUP_MYSQL_DIR (${CLEANUP_MYSQL_DIR}) does not exist and can't be created. MySQL-file generation skipped." >> $LOGFILE
        echo "...Failed."
        return $FALSE
        #===
    fi

    check_folder $TMP_DIR
    if [[ "$?" -gt $TRUE ]]; then
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: TMP_DIR (${TMP_DIR}) does not exist. MySQL-file generation skipped." >> $LOGFILE
        echo "...Failed."
        return $FALSE
        #===
    fi

    #--------------------------------------------------------------------------
    # Combine this files with the default queries if they exists
    # Default
    if [ -f ${CLEANUP_MYSQL_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql ]; then
        cat ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.structure.sql ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.data.sql ${CLEANUP_MYSQL_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql > ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql
        echo "Successfully created default MySQL file with cleanups for '${MYSQL_DATABASE_SOURCE}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully created default MySQL file with cleanups for database '${MYSQL_DATABASE_SOURCE}'." >> $LOGFILE
    else
        cat ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.structure.sql ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.data.sql > ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql
        echo "Successfully created default MySQL file without cleanups for '${MYSQL_DATABASE_SOURCE}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully created default MySQL file without cleanups for for database '${MYSQL_DATABASE_SOURCE}'." >> $LOGFILE
    fi

    #--------------------------------------------------------------------------
    # For Dev
    if [ -f ${CLEANUP_MYSQL_DIR}/${MYSQL_DATABASE_SOURCE}.dev.sql ]; then
        cat ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql ${CLEANUP_MYSQL_DIR}/${MYSQL_DATABASE_SOURCE}.dev.sql > ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.dev.sql
        echo "Successfully created MySQL file for development with cleanups for '${MYSQL_DATABASE_SOURCE}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully created MySQL file for development with cleanups for for database '${MYSQL_DATABASE_SOURCE}'." >> $LOGFILE
    else
        cp ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.dev.sql
        echo "Successfully created MySQL file for development without cleanups for '${MYSQL_DATABASE_SOURCE}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully created MySQL file for development without cleanups for for database '${MYSQL_DATABASE_SOURCE}'." >> $LOGFILE
    fi

    #--------------------------------------------------------------------------
    # For Stage
    if [ -f ${CLEANUP_MYSQL_DIR}/${MYSQL_DATABASE_SOURCE}.stage.sql ]; then
        cat ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql ${CLEANUP_MYSQL_DIR}/${MYSQL_DATABASE_SOURCE}.stage.sql > ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.stage.sql
        echo "Successfully created MySQL file for staging with cleanups for '${MYSQL_DATABASE_SOURCE}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully created MySQL file for staging with cleanups for for database '${MYSQL_DATABASE_SOURCE}'." >> $LOGFILE
    else
        cp ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.stage.sql
        echo "Successfully created MySQL file for staging without cleanups for '${MYSQL_DATABASE_SOURCE}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully created MySQL file for staging without cleanups for for database '${MYSQL_DATABASE_SOURCE}'." >> $LOGFILE
    fi

    #--------------------------------------------------------------------------
    # Cleanup
    rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql
    rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.structure.sql
    rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.data.sql

    echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: MySQL-file generation completed." >> $LOGFILE
    if [[ $hasError -eq 1 ]]; then
        echo "...Failed."
        return $FALSE
        #===
    fi

    echo "...Completed."
    return $TRUE
    #===
}

# ============================================================================
function import_mysql () {

    local hasError=0
    local type=$1
    local mysqlUser=${MYSQL_USER_DEV}
    local mysqlPass=${MYSQL_PASS_DEV}
    local mysqlHost=${MYSQL_HOST_DEV}
    local mysqlDatabase=${MYSQL_DATABASE_DEV}

     if [[ $type == "stage" ]]; then
        mysqlUser=${MYSQL_USER_STAGE}
        mysqlPass=${MYSQL_PASS_STAGE}
        mysqlHost=${MYSQL_HOST_STAGE}
        mysqlDatabase=${MYSQL_DATABASE_STAGE}
     fi

    echo "Starting MySQL import for database '${mysqlDatabase}'..."

    check_folder $TMP_DIR
    if [[ "$?" -gt $TRUE ]]; then
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: TMP_DIR (${TMP_DIR}) does not exist. MySQL-Import skipped." >> $LOGFILE
        echo "...Failed."
        return $FALSE
        #===
    fi

    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.${type}.sql ]; then

        #-------------------------------------------------------------------------
        # delete existing tables of current database
        flush_mysql_database "${type}"

        #--------------------------------------------------------------------------
        # import the dump
        echo "Import of MySQL file for database '${mysqlDatabase}'..."
        $MYSQL -u ${mysqlUser} -h ${mysqlHost} -p${mysqlPass} ${mysqlDatabase} 2>&1 < ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.${type}.sql 2>/dev/null
        if  [[ "$?" -gt $TRUE ]]; then
            echo "Error while trying to import database for '${mysqlDatabase}'."
            echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Error while trying to import database for database '${mysqlDatabase}'." >> $LOGFILE
            hasError=1
        else
            echo "Successfully imported database for '${mysqlDatabase}'."
            echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Successfully imported database for databse '${mysqlDatabase}'." >> $LOGFILE
        fi

        #--------------------------------------------------------------------------
        # Cleanup type-file
        rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.${type}.sql

    else
        echo "No current dump of type ${type} found for '${MYSQL_DATABASE_SOURCE}'."
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: No current dump of type ${type} found for database '${MYSQL_DATABASE_SOURCE}'." >> $LOGFILE
    fi

    if [[ $hasError -eq 1 ]]; then
        echo "...Failed."
        return $FALSE
        #===
    fi

    echo "...Completed."
    return $TRUE
    #===
}


# ============================================================================
function flush_mysql_database () {

    local hasError=0
    local type=$1
    local mysqlUser=${MYSQL_USER_DEV}
    local mysqlPass=${MYSQL_PASS_DEV}
    local mysqlHost=${MYSQL_HOST_DEV}
    local mysqlDatabase=${MYSQL_DATABASE_DEV}

     if [[ $type == "stage" ]]; then
        mysqlUser=${MYSQL_USER_STAGE}
        mysqlPass=${MYSQL_PASS_STAGE}
        mysqlHost=${MYSQL_HOST_STAGE}
        mysqlDatabase=${MYSQL_DATABASE_STAGE}
     fi

    echo "Starting flush of MySQL database '${mysqlDatabase}'..."

    # delete existing tables
    TABLES=$($MYSQL -u ${mysqlUser} -h ${mysqlHost} -p${mysqlPass} ${mysqlDatabase} -e 'show tables' 2>&1 2>/dev/null | $AWK '{ print $1}' | $GREP -v '^Tables' )
    for table in $TABLES
    do
        # echo "Droping table '${table}' from ${mysqlDatabase}..."
        # echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Droping table '${table}' from '${mysqlDatabase}'." >> $LOGFILE
        $MYSQL -u ${mysqlUser} -h ${mysqlHost} -p${mysqlPass} ${mysqlDatabase} -e "drop table ${table}" 2>&1 2>/dev/null
    done

    if [[ $hasError -eq 1 ]]; then
        echo "...Failed."
        return $FALSE
        #===
    fi

    echo "...Completed."
    return $TRUE
    #===
}


# ============================================================================
function generate_tar_files () {

    local hasError=0
    local type=$1
    local mysqlUser=${MYSQL_USER_DEV}
    local mysqlPass=${MYSQL_PASS_DEV}
    local mysqlHost=${MYSQL_HOST_DEV}
    local mysqlDatabase=${MYSQL_DATABASE_DEV}

     if [[ $type == "stage" ]]; then
        mysqlUser=${MYSQL_USER_STAGE}
        mysqlPass=${MYSQL_PASS_STAGE}
        mysqlHost=${MYSQL_HOST_STAGE}
        mysqlDatabase=${MYSQL_DATABASE_STAGE}
     fi

    echo "Starting to generate TAR-files for database '${mysqlDatabase}'..."

    check_folder $TMP_DIR
    if [[ "$?" -gt $TRUE ]]; then
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: TMP_DIR (${TMP_DIR}) does not exist. Generation of TAR-files skipped." >> $LOGFILE
        echo "...Failed."
        return $FALSE
        #===
    fi

    check_folder $DESTINATION_DIR
    if [[ "$?" -gt $TRUE ]]; then
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: DESTINATION_DIR (${DESTINATION_DIR}) does not exist. Generation of TAR-files skipped." >> $LOGFILE
        echo "...Failed."
        return $FALSE
        #===
    fi

    nocache tar -cpzf ${DESTINATION_DIR}/${MYSQL_DATABASE_SOURCE}.${type}.tar.gz -C ${TMP_DIR} ${mysqlDatabase}.structure.sql ${mysqlDatabase}.data.sql 2>>${LOGFILE} 1>>${LOGFILE} 2>&1

    echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Generation of TAR-files for database '${mysqlDatabase}' completed." >> $LOGFILE
    if [[ $hasError -eq 1 ]]; then
        echo "...Failed."
        return $FALSE
        #===
    fi

    echo "...Completed."
    return $TRUE
    #===
}

# ============================================================================
function cleanup () {

  	echo "Starting cleanup..."

    check_folder $TMP_DIR
    if [[ "$?" -gt $TRUE ]]; then
        echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: TMP_DIR (${TMP_DIR}) does not exist. Cleanup skipped." >> $LOGFILE
        echo "Failed."
        return $FALSE
        #===
    fi

    # Cleanup for build
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql ]; then
   	    rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.default.sql
    fi
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.dev.sql ]; then
        rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.dev.sql
    fi
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.stage.sql ]; then
        rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.stage.sql
    fi


    # Cleanup for dumps
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.structure.sql ]; then
        rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.structure.sql
    fi
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.data.sql ]; then
        rm ${TMP_DIR}/${MYSQL_DATABASE_SOURCE}.data.sql
    fi
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_DEV}.structure.sql ]; then
        rm ${TMP_DIR}/${MYSQL_DATABASE_DEV}.structure.sql
    fi
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_DEV}.data.sql ]; then
        rm ${TMP_DIR}/${MYSQL_DATABASE_DEV}.data.sql
    fi
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_STAGE}.structure.sql ]; then
        rm ${TMP_DIR}/${MYSQL_DATABASE_STAGE}.structure.sql
    fi
    if [ -f ${TMP_DIR}/${MYSQL_DATABASE_STAGE}.data.sql ]; then
        rm ${TMP_DIR}/${MYSQL_DATABASE_STAGE}.data.sql
    fi

    echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: Cleanup completed." >> $LOGFILE
    if [[ $hasError -eq 1 ]]; then
        echo "...Failed."
        return $FALSE
        #===
    fi

    echo "...Completed."
    return $TRUE
    #===

}

# ============================================================================
# Cases
# ============================================================================

hasError=0
case "$1" in
    all)

    ;&
    dev)
        dump_mysql "source"
        if [[ "$?" -gt $TRUE ]]; then
            hasError=1
        fi

        if [[ "$hasError" == 0 ]]; then
            generate_mysql_files
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi

        if [[ "$hasError" == 0 ]]; then
            import_mysql "dev"
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi

        if [[ "$hasError" == 0 ]]; then
            dump_mysql "dev" 1
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi

        if [[ "$hasError" == 0 ]]; then
            generate_tar_files "dev"
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi

        if [[ "$hasError" == 0 ]]; then
            flush_mysql_database "dev"
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi

        if [[ "$hasError" == 0 ]]; then
            cleanup
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi
    ;;
    stage)
        dump_mysql "source"
        if [[ "$?" -gt $TRUE ]]; then
            hasError=1
        fi

        if [[ "$hasError" == 0 ]]; then
            generate_mysql_files
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi

        if [[ "$hasError" == 0 ]]; then
            import_mysql "stage"
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi

        #if [[ "$hasError" == 0 ]]; then
        #    dump_mysql "stage" 1
        #    if [[ "$?" -gt $TRUE ]]; then
        #        hasError=1
        #    fi
        #fi

        #if [[ "$hasError" == 0 ]]; then
        #     generate_tar_files "stage"
        #     if [[ "$?" -gt $TRUE ]]; then
        #         hasError=1
        #     fi
        #fi

        if [[ "$hasError" == 0 ]]; then
            cleanup
            if [[ "$?" -gt $TRUE ]]; then
                hasError=1
            fi
        fi
    ;;
    *)
        echo "Usage $0 {dev|stage|all}"
        exit 0;
    ;;
esac

if [[ $hasError -eq 1 ]]; then
    echo "Date: $(date +%d-%m-%Y) $(date +%H:%M:%S), Message: MySQL-Dumper failed! (Start: ${START}h, End: $(date +%H:%M:%S)h)" >> $LOGFILE
    tail $LOGFILE -n 50 | mail -s "${SERVER_NAME}: MySQL-Dumper failed!" $EMAIL
    exit 2;
fi

echo "DONE!"
tail $LOGFILE -n 50 | mail -s "${SERVER_NAME}: MySQL-Dumper successful! (Start: ${START}h, End: $(date +%H:%M:%S)h)" $EMAIL
exit 0;
