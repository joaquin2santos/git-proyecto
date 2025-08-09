#!/bin/bash

SERVICIOS=("nginx" "mysql" "docker")
SERVICIOS_CAIDOS=()

for servicio in "${SERVICIOS[@]}"; do
	systemctl is-active --quiet "$servicio"
	if [ $? -eq 0 ]; then
		echo "$servicio está activo"
	else
		echo "$servicio está caído"
		SERVICIOS_CAIDOS+=("$servicio")
	fi
done

# Si alguno está caído, enviar mail
if [ ${#SERVICIOS_CAIDOS[@]} -gt 0 ]; then
	ASUNTO="Alerta: Servicios caídos"
	CUERPO="Los siguientes servicios están caídos: ${SERVICIOS_CAIDOS[*]}"
	DESTINO="tu_email@dominio.com"

	echo "$CUERPO" | mail -s "$ASUNTO" "$DESTINO"
fi
