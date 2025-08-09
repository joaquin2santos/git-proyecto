#!/bin/bash
# Recibe dos numeros como argumentos y muestra el resultado de la multiplicacion

#!/bin/bash
# Multiplica dos números recibidos como argumentos y muestra el resultado

if [ $# -ne 2 ]; then
	echo "❌ Error: faltan argumentos."
	exit 1
fi

num1=$1
num2=$2
resultado=$((num1 * num2))

echo "El resultado de multiplicar $num1 por $num2 es: $resultado"
