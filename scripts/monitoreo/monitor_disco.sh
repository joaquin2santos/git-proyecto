#!/bin/bash

ADMIN="admin@ejemplo.com"
LOGFILE="/home/joaco/monitor_disco.log"

FECHA=$(date '+%Y-%m-%d %H:%M:%S')

USO_RAIZ=$(df / | awk 'NR==2 {print $5}' | sed 's/%//g')
TAMANO_HOME=$(du -sh /home | awk '{print $1}' | sed 's/G//g')

# Guardar estado actual en el log
echo "[$FECHA] Uso /: ${USO_RAIZ}%" >>"$LOGFILE"
echo "[$FECHA] Tamaño /home: ${TAMANO_HOME}GB" >>"$LOGFILE"

# Verificar uso raíz y enviar mail si es necesario
if [ "$USO_RAIZ" -ge 90 ]; then
	echo "¡Alerta: Partición / al ${USO_RAIZ}%!" | mail -s "Alerta Partición /" $ADMIN
	echo "[$FECHA] ALERTA: Partición / al ${USO_RAIZ}%" >>"$LOGFILE"
fi

# Verificar tamaño /home y enviar mail si es necesario
if (($(echo "$TAMANO_HOME > 2" | bc -l))); then
	echo "¡Alerta: /home ocupa ${TAMANO_HOME}GB!" | mail -s "Alerta Directorio /home" $ADMIN
	echo "[$FECHA] ALERTA: /home ocupa ${TAMANO_HOME}GB" >>"$LOGFILE"
fi
