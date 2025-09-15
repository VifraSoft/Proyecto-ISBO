#!/bin/bash

# ========= SCRIPT DE GESTIÓN DE FIREWALLD =========
# Debe ejecutarse como root

if [[ "$EUID" -ne 0 ]]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi

pausar() {
  read -p "Presione Enter para continuar..."
}

activar_firewall() {
  systemctl start firewalld
  systemctl enable firewalld
  echo "Firewall activado y configurado para iniciar con el sistema."
}

desactivar_firewall() {
  systemctl stop firewalld
  systemctl disable firewalld
  echo "Firewall detenido y deshabilitado."
}

activar_servicio() {
  read -p "Ingrese el nombre del servicio : " servicio
  firewall-cmd --permanent --add-service=$servicio
  firewall-cmd --reload
  echo "Servicio '$servicio' habilitado."
}

desactivar_servicio() {
  read -p "Ingrese el nombre del servicio : " servicio
  firewall-cmd --permanent --remove-service=$servicio
  firewall-cmd --reload
  echo "Servicio '$servicio' deshabilitado."
}

activar_puerto() {
  read -p "Ingrese el puerto : " puerto
  firewall-cmd --permanent --add-port=$puerto
  firewall-cmd --reload
  echo "Puerto '$puerto' habilitado."
}

desactivar_puerto() {
  read -p "Ingrese el puerto : " puerto
  firewall-cmd --permanent --remove-port=$puerto
  firewall-cmd --reload
  echo "Puerto '$puerto' deshabilitado."
}

agregar_rich_rule() {
  read -p "Ingrese la regla completa : " regla
  firewall-cmd --permanent --add-rich-rule="$regla"
  firewall-cmd --reload
  echo "Rich Rule agregada: $regla"
}

listar_reglas() {
  echo "=== Reglas actuales en el firewall ==="
  firewall-cmd --list-all
}

mostrar_menu() {
  clear
  echo "========= MENÚ FIREWALLD ========="
  echo "1) Activar firewall"
  echo "2) Desactivar firewall"
  echo "3) Activar servicio por nombre"
  echo "4) Desactivar servicio por nombre"
  echo "5) Activar puerto"
  echo "6) Desactivar puerto"
  echo "7) Agregar Rich Rule"
  echo "8) Listar reglas actuales"
  echo "0) Salir"
  echo "=================================="
}

opcion=-1
while [[ $opcion -ne 0 ]]; do
  mostrar_menu
  read -p "Seleccione una opción: " opcion
  case $opcion in
    1) activar_firewall; pausar ;;
    2) desactivar_firewall; pausar ;;
    3) activar_servicio; pausar ;;
    4) desactivar_servicio; pausar ;;
    5) activar_puerto; pausar ;;
    6) desactivar_puerto; pausar ;;
    7) agregar_rich_rule; pausar ;;
    8) listar_reglas; pausar ;;
    0) echo "Saliendo..." ;;
    *) echo "Opción no válida."; pausar ;;
  esac
done
