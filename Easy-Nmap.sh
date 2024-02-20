#!/bin/#!/bin/bash

# Función para validar la dirección IP
function validar_ip {
    local ip=$1
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Función para gestionar errores
function gestionar_errores {
    local mensaje=$1
    echo "Error: $mensaje"
    exit 1
}

# Función para manejar señales
function manejar_seniales {
    echo "Saliendo del script..."
    exit 0
}

# Función para verificar dependencias
function verificar_dependencias {
    if ! command -v nmap &> /dev/null; then
        gestionar_errores "Nmap no está instalado. Por favor, instálalo antes de continuar."
    fi
}

# Función para mostrar ayuda
function mostrar_ayuda {
    echo "Uso: $0 [opciones]"
    echo "Opciones disponibles:"
    echo "  -h, --help         Mostrar este mensaje de ayuda"
    echo "  -t, --timeout      Especificar el tiempo de espera para el escaneo"
    echo "  -s, --speed        Especificar la velocidad del escaneo"
    echo "  -v, --verbosity    Especificar el nivel de detalle de la salida"
}

# Función para registrar actividad
function registrar_actividad {
    local mensaje=$1
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $mensaje" >> actividad.log
}

# Manejo de señales
trap manejar_seniales SIGINT SIGTERM

# Verificar dependencias
verificar_dependencias

# Bienvenida
echo "
▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
▐  ██████████                                         ██████   █████                                     ▌
▐ ░░███░░░░░█                                        ░░██████ ░░███                                      ▌
▐  ░███  █ ░   ██████    █████  █████ ████            ░███░███ ░███  █████████████    ██████   ████████  ▌
▐  ░██████    ░░░░░███  ███░░  ░░███ ░███  ██████████ ░███░░███░███ ░░███░░███░░███  ░░░░░███ ░░███░░███ ▌
▐  ░███░░█     ███████ ░░█████  ░███ ░███ ░░░░░░░░░░  ░███ ░░██████  ░███ ░███ ░███   ███████  ░███ ░███ ▌
▐  ░███ ░   █ ███░░███  ░░░░███ ░███ ░███             ░███  ░░█████  ░███ ░███ ░███  ███░░███  ░███ ░███ ▌
▐  ██████████░░████████ ██████  ░░███████             █████  ░░█████ █████░███ █████░░████████ ░███████  ▌
▐ ░░░░░░░░░░  ░░░░░░░░ ░░░░░░    ░░░░░███            ░░░░░    ░░░░░ ░░░░░ ░░░ ░░░░░  ░░░░░░░░  ░███░░░   ▌
▐  By Klofenix                   ███ ░███                                                      ░███      ▌
▐                               ░░██████                                                       █████     ▌
▐                                ░░░░░░                                                       ░░░░░      ▌
▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
"

# Solicitar la dirección IP
while true; do
    echo "Introduce la dirección IP a escanear:"
    read ip
    if validar_ip "$ip"; then
        break
    else
        gestionar_errores "Dirección IP no válida. Por favor, inténtalo de nuevo."
    fi
done

clear

# Solicitar el nombre del proyecto
echo "¿Cuál es el nombre del proyecto?"
read proyecto


# Crear la estructura de carpetas
mkdir -p "$proyecto/informes"
mkdir -p "$proyecto/imagenes"
mkdir -p "$proyecto/anotaciones"
clear

# Solicitar el rango de puertos
echo "Introduce el rango de puertos a escanear (por ejemplo, 1-100, o un solo puerto):"
read puertos

# Solicitar la opción de formato de salida
echo "Selecciona el tipo de formato de salida:"
echo "1. Texto plano (.txt)"
echo "2. XML (.xml)"
echo "3. Formato Grepable (.gnmap)"
echo "4. Todos los formatos"
read formato

clear

# Verificar el formato seleccionado y configurar Nmap
case $formato in
    1)
        formato_opcion="-oN" ;;
    2)
        formato_opcion="-oX" ;;
    3)
        formato_opcion="-oG" ;;
    4)
        formato_opcion="-oA" ;;
    *)
        gestionar_errores "Opción de formato no válida. Saliendo del script." ;;
esac

# Solicitar la opción de ejecución
echo "Selecciona una opción de ejecución:"
echo "1. Silencioso"
echo "2. Normal"
echo "3. Rompelo"
read opcion
clear

# Verificar el opción seleccionada y configurar Nmap
case $opcion in
    1)
        nmap -p $puertos -sS -Pn $ip $formato_opcion "$proyecto/informes/nmap_scan" ;;
    2)
        nmap -p $puertos -sV -O --script=default $ip $formato_opcion "$proyecto/informes/nmap_scan" ;;
    3)
        nmap -p $puertos -A --script=vuln $ip $formato_opcion "$proyecto/informes/nmap_scan" ;;
    *)
        gestionar_errores "Opción de ejecución no válida. Saliendo del script." ;;
esac

# Registro de actividad
registrar_actividad "Escaneo completado para la dirección IP $ip en el proyecto $proyecto"
