#!/bin/bash

# ========= SCRIPT DE BACKUPS MANUALES =========
# Debe ejecutarse como root para tener permisos completos.

if [[ "$EUID" -ne 0 ]]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi
ORIGEN="/etc"                 
DESTINO="/var/backups"        
FECHA=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$DESTINO"

backup_full() {
  ARCHIVO="$DESTINO/backup_full_$FECHA.tar.gz"
  tar -czvf "$ARCHIVO" "$ORIGEN"
  echo "Backup FULL creado en: $ARCHIVO"
}

backup_incremental() {
  ARCHIVO="$DESTINO/backup_incremental_$FECHA.tar.gz"

  tar --listed-incremental="$DESTINO/snapshot.snar" -czvf "$ARCHIVO" "$ORIGEN"
  echo "Backup INCREMENTAL creado en: $ARCHIVO"
}

backup_diferencial() {
  ARCHIVO="$DESTINO/backup_diferencial_$FECHA.tar.gz"
  
  tar --newer-mtime="$(date -d 'last sunday' +%Y-%m-%d)" -czvf "$ARCHIVO" "$ORIGEN"
  echo "Backup DIFERENCIAL creado en: $ARCHIVO"
}


mostrar_menu() {
  clear
  echo "========= MENÚ BACKUPS ========="
  echo "1) Crear backup FULL"
  echo "2) Crear backup INCREMENTAL"
  echo "3) Crear backup DIFERENCIAL"
  echo "0) Salir"
  echo "================================"
}

pausar() {
  read -p "Presione Enter para continuar..."
}

opcion=-1
while [[ $opcion -ne 0 ]]; do
  mostrar_menu
  read -p "Seleccione una opción: " opcion
  case $opcion in
    1) backup_full; pausar ;;
    2) backup_incremental; pausar ;;
    3) backup_diferencial; pausar ;;
    0) echo "Saliendo..." ;;
    *) echo "Opción no válida."; pausar ;;
  esac
done
