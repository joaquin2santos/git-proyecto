#!/bin/bash

LOG="logs_pm2.txt"
REPO="https://github.com/roxsross/devops-static-web.git"
RAMA="ecommerce-ms"

APP_BASE_DIR="/mnt/c/Users/BANGHO/Desktop/facultad/devops-90/git-proyecto/scripts/despliegue"
APP_DIR="$APP_BASE_DIR/devops-static-web_2"

APPS=("frontend" "merchandise" "products" "shopping-cart")

echo "=== Inicio despliegue Node.js con PM2 ===" | tee $LOG

# 1. Instalar Node.js, npm y PM2 si no están presentes
echo "Verificando Node.js y npm..." | tee -a $LOG
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
	echo "Node.js o npm no están instalados. Instalando..." | tee -a $LOG
	curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - >>$LOG 2>&1
	sudo apt-get install -y nodejs >>$LOG 2>&1
else
	echo "Node.js y npm ya están instalados." | tee -a $LOG
fi

echo "Verificando PM2..." | tee -a $LOG
if ! command -v pm2 >/dev/null 2>&1; then
	echo "PM2 no está instalado. Instalando globalmente..." | tee -a $LOG
	sudo npm install -g pm2 >>$LOG 2>&1
else
	echo "PM2 ya está instalado." | tee -a $LOG
fi

# Crear directorio base si no existe
mkdir -p "$APP_BASE_DIR"

# 2. Clonar o actualizar repositorio
if [ -d "$APP_DIR" ]; then
	echo "El directorio $APP_DIR ya existe. Actualizando repo..." | tee -a $LOG
	cd "$APP_DIR"
	git fetch origin >>../$LOG 2>&1
	git checkout $RAMA >>../$LOG 2>&1
	git pull origin $RAMA >>../$LOG 2>&1
	cd -
else
	echo "Clonando repositorio rama $RAMA en $APP_DIR..." | tee -a $LOG
	git clone -b $RAMA $REPO "$APP_DIR" >>$LOG 2>&1
fi

# 3. Para cada app: instalar dependencias e iniciar con PM2
cd "$APP_DIR"
for app in "${APPS[@]}"; do
	echo "Desplegando aplicación $app..." | tee -a ../$LOG
	cd "$app"

	if [ -f package.json ]; then
		npm install >>../../$LOG 2>&1
		pm2 start npm --name "ecommerce-$app" -- start >>../../$LOG 2>&1
	else
		echo "⚠️ package.json no encontrado en $app, saltando..." | tee -a ../../$LOG
	fi

	cd ..
done

# 4. Guardar configuración PM2 para reinicio automático
echo "Guardando configuración PM2 para reinicio automático..." | tee -a ../$LOG
pm2 save >>../$LOG 2>&1

echo "=== Despliegue finalizado ===" | tee -a ../$LOG
echo "Para ver el estado de las apps: pm2 list" | tee -a ../$LOG
echo "Para ver logs: pm2 logs" | tee -a ../$LOG
