#!/bin/bash
set -x
# set -e
# monitor_cpu.sh

LOG_ALERTAS="/home/tu_usuario/alertas_cpu.log"
INTENTOS=0
MAX_INTENTOS=3
UMBRAL=85

while true; do
	# Obtener porcentaje de uso de CPU (usuario + sistema) con top o mpstat, ejemplo con mpstat:
	CPU_USAGE=$(mpstat 1 1 | awk '/Average/ {print 100 - $NF}')
	CPU_ENTERO=${CPU_USAGE%.*} # parte entera

	FECHA=$(date '+%Y-%m-%d %H:%M:%S')
	echo "[$FECHA] Uso CPU: $CPU_USAGE%"

	if [ "$CPU_ENTERO" -gt "$UMBRAL" ]; then
		INTENTOS=$((INTENTOS + 1))
		echo "[$FECHA] Alerta: CPU > $UMBRAL% ($INTENTOS/$MAX_INTENTOS)" >>"$LOG_ALERTAS"
	else
		INTENTOS=0
	fi

	if [ "$INTENTOS" -ge "$MAX_INTENTOS" ]; then
		echo "[$FECHA] CPU sobrepasó el $UMBRAL% tres veces consecutivas. Cortando monitoreo." >>"$LOG_ALERTAS"
		break
	fi

	sleep 5 # Espera 5 segundos antes de la próxima lectura
done
