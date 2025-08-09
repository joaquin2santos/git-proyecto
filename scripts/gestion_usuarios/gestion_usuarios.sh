#!/bin/bash
source ./funciones.sh

if [[ $# -ne 1 ]]; then
	echo "Uso: $0 <nombre_usuario>"
	exit 1
fi

crear_usuario "$1"
