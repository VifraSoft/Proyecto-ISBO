#!/bin/bash

# ========= GESTIÓN DE USUARIOS Y GRUPOS =========
# Este script debe ejecutarse como root.

if [[ "$EUID" -ne 0 ]]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi

crear_usuario() {
  read -p "Ingrese el nombre del usuario a crear: " usuario
  if id "$usuario" &>/dev/null; then
    echo "El usuario '$usuario' ya existe."
  else
    useradd "$usuario"
    echo "Usuario '$usuario' creado con éxito."
  fi
}

crear_grupo() {
  read -p "Ingrese el nombre del grupo a crear: " grupo
  if getent group "$grupo" &>/dev/null; then
    echo "El grupo '$grupo' ya existe."
  else
    groupadd "$grupo"
    echo "Grupo '$grupo' creado con éxito."
  fi
}

listar_usuarios() {
  echo "=== Lista de usuarios ==="
  cut -d: -f1 /etc/passwd
}

listar_grupos() {
  echo "=== Lista de grupos ==="
  cut -d: -f1 /etc/group
}

mover_usuario_a_grupo() {
  read -p "Ingrese el usuario a mover: " usuario
  read -p "Ingrese el grupo destino: " grupo
  if id "$usuario" &>/dev/null && getent group "$grupo" &>/dev/null; then
    usermod -aG "$grupo" "$usuario"
    echo "El usuario '$usuario' fue agregado al grupo '$grupo'."
  else
    echo "El usuario o el grupo no existen."
  fi
}


pausar() {
  read -p "Presione Enter para continuar..."
}


mostrar_menu() {
  clear
  echo "========= MENÚ ========="
  echo "1) Crear usuario"
  echo "2) Crear grupo"
  echo "3) Listar usuarios"
  echo "4) Listar grupos"
  echo "5) Mover usuario a grupo"
  echo "0) Salir"
  echo "========================"
}



opcion=-1
while [[ $opcion -ne 0 ]]; do
  mostrar_menu
  read -p "Seleccione una opción: " opcion
  case $opcion in
    1) crear_usuario; pausar ;;
    2) crear_grupo; pausar ;;
    3) listar_usuarios; pausar ;;
    4) listar_grupos; pausar ;;
    5) mover_usuario_a_grupo; pausar ;;
    0) echo "Saliendo...";;
    *) echo "Opción no válida."; pausar ;;
  esac
done
