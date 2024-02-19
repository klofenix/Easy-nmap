#!/bin/bash

# Solicitar el nombre del proyecto
echo "¿Cuál es el nombre del proyecto?"
read proyecto

# Crear la estructura de carpetas
mkdir -p "$proyecto/informes"
mkdir -p "$proyecto/imagenes"
mkdir -p "$proyecto/anotaciones"

# Solicitar la dirección IP
echo "Introduce la dirección IP a escanear:"
read ip

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
        echo "Opción no válida. Seleccionando todos los formatos."
        formato_opcion="-oA" ;;
esac

# Solicitar la opción de ejecución
echo "Selecciona una opción de ejecución:"
echo "1. Silencioso"
echo "2. Normal"
echo "3. Rompelo"
read opcion

# Verificar la opción seleccionada y configurar Nmap
case $opcion in
    1)
        nmap -p $puertos -sS -Pn $ip $formato_opcion "$proyecto/informes/nmap_scan" ;;
    2)
        nmap -p $puertos -sV -O --script=default $ip $formato_opcion "$proyecto/informes/nmap_scan" ;;
    3)
        nmap -p $puertos -A --script=vuln $ip $formato_opcion "$proyecto/informes/nmap_scan" ;;
    *)
        echo "Opción no válida. Saliendo del script." ;;
esac
