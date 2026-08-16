# Web Recon Tool

Script en Bash para automatizar herramientas de reconocimiento web.

## Descripción

Menú interactivo que centraliza y automatiza el uso de herramientas de reconocimiento y explotación web, generando resultados organizados por fecha en un directorio local.

## Herramientas integradas

- **Nmap** — escaneo de puertos con 4 modos (paranoico, agresivo, balanceado, rápido)
- **Gobuster** — descubrimiento de directorios/archivos, subdominios (DNS) y vhosts
- **WhatWeb** — fingerprinting de tecnologías web
- **Nikto** — escaneo de vulnerabilidades web
- **SQLMap** — detección y explotación de inyección SQL

## Requisitos

- Bash
- [nmap](https://nmap.org/)
- [gobuster](https://github.com/OJ/gobuster)
- [whatweb](https://github.com/urbanadventurer/WhatWeb)
- [nikto](https://github.com/sullo/nikto)
- [sqlmap](https://github.com/sqlmapproject/sqlmap)
- [SecLists](https://github.com/danielmiessler/SecLists) instalado en `/usr/share/seclists`

## Uso

```bash
chmod +x racun_web.sh
./racun_web.sh <IP_o_dominio>
```

Se mostrará un menú donde puedes elegir la herramienta a ejecutar. Los resultados se guardan en un directorio `recon_YYYYMMDD/` creado automáticamente.
Hay que ajustar el PATH para el correcto funcionamiento.
## Estructura de resultados

```
recon_YYYYMMDD/
├── nmap_scan
├── gobuster_scan.txt
├── whatweb.log
├── nikto_scan.txt
└── sqlmap/
```

## Advertencia legal

Este script está pensado **exclusivamente** para uso en entornos de práctica autorizados (HackTheBox, TryHackMe, laboratorios propios, CTFs) o en sistemas donde se cuente con autorización explícita para realizar pruebas de seguridad. El uso no autorizado de estas herramientas contra sistemas de terceros es ilegal.

## Autor

Proyecto personal para automatizar flujo de trabajo en CTFs.
