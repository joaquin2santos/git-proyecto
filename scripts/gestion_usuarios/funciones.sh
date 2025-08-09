#!/bin/bash
crear_usuario() {
	local usuario=$1

	if id "$usuario" &>/dev/null; then
		echo "El usuario $usuario ya existe."
	else
		sudo useradd "$usuario"
		if [ $? -eq 0 ]; then
			echo "Usuario $usuario creado el $(date)" >>usuarios.log
			echo "Usuario $usuario creado."
		else
			echo "Error creando el usuario $usuario."
		fi
	fi
}
