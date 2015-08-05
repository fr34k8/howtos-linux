# Bash

## Einfacher regular expression in bash mit sed

	AUSGABE=$(echo $TEST | sed 's/.://g')

## Increment einer variabel auf zwei arten mit bash

	ERROR_COUNT=$((ERROR_COUNT+1))

## Logfile umleiten

	LOGFILE="/tmp/`basename "$0" .sh`.log"
	exec 1>${LOGFILE}
	exec 2>&1

## Datum

	BACKUP_DATE=$(date +%Y%m%d-%H%M)
	BackupDate=$(date -d "-1 day" +"%Y-%m-%d")
