#!/bin/bash
# Pide nombre, edad y muestra un mensaje personalizado

read -p "¿Cual es tu nombre? " nombre
read -p "¿Cuantos años tenes? " edad

echo "Hola $nombre, tenes $edad años. ¡Bienvenido al mundo bash!"
