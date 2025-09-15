#!/bin/bash

# ========= SCRIPT PRINCIPAL =========
# Debe ejecutarse como root

if [[ "$EUID" -ne 0 ]]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi

pausar() {
  read -p "Presione Enter para continuar..."
}

mostrar_menu() {
  clear
  echo "========= MENÚ PRINCIPAL ========="
  echo "1) Gestión de Usuarios y Grupos"
  echo "2) Backups Manuales"
  echo "3) Configuración de Firewalld"
  echo "0) Salir"
  echo "================================="
}

opcion=-1
while [[ $opcion -ne 0 ]]; do
  mostrar_menu
  read -p "Seleccione una opción: " opcion
  case $opcion in
    1) bash /home/vifrasoft/scripts/UG.sh; pausar ;;
    2) bash /home/vifrasoft/scripts/backups.sh; pausar ;;
    3) bash /home/vifrasoft/scripts/Firewalld.sh; pausar ;;
    0) echo "Saliendo..." ;;
    *) echo "Opción no válida."; pausar ;;
  esac
done
