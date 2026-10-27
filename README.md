![SonarQube](https://img.shields.io/badge/SonarQube-Community-4E9BCD?logo=sonarqube)
![Snyk](https://img.shields.io/badge/Snyk-CLI-005EFF?logo=snyk)
![Node.js](https://img.shields.io/badge/Node.js-Express-339933?logo=node.js)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)
![GitHub](https://img.shields.io/badge/GitHub-Actions-2088FF?logo=github)

# SAST - IsraelStarTeam

Proyecto educativo para demostrar el uso de herramientas de SAST (Static Application Security Testing) con SonarQube y Snyk sobre una aplicacion vulnerable de ejemplo.

## Descripcion

Este repositorio contiene una demostracion pratica de analisis estatico de codigo. Se utiliza el proyecto OWASP NodeGoat como ejemplo vulnerable, el cual incluye fallos de seguridad intencionales mapeados al OWASP Top 10, falta de cobertura de pruebas y problemas de mantenibilidad.

El objetivo es mostrar como herramientas como SonarQube y Snyk pueden identificar automaticamente vulnerabilidades, bugs y code smells sin necesidad de ejecutar la aplicacion.

## Caracteristicas principales

- Analisis estatico de codigo con SonarQube y SonarScanner.
- Deteccion de vulnerabilidades en codigo y dependencias con Snyk.
- Levantamiento local de SonarQube mediante Docker Compose.
- Guia paso a paso para ejecutar los analisis.
- Proyecto de demostracion basado en OWASP NodeGoat.

## Herramientas incluidas

| Herramienta | Propuesto | Rama |
|-------------|-----------|------|
| SonarQube + SonarScanner | Analisis de calidad, bugs, vulnerabilidades y code smells | demo/sonarqube |
| Snyk CLI | Deteccion de vulnerabilidades en codigo y dependencias | main |

## Proyecto de demostracion

Se utiliza OWASP NodeGoat como aplicacion vulnerable de ejemplo.

- Repositorio: https://github.com/OWASP/NodeGoat
- Lenguaje: JavaScript (Node.js)
- Framework: Express
- Base de datos: MongoDB
- Motivo: contiene vulnerabilidades intencionales mapeadas al OWASP Top 10, errores evidentes y visibles, y falta de cobertura de pruebas.

## Estructura del repositorio

```
SAST-IsraelStarTeam/
├── README.md
├── .gitignore
├── docs/
│   └── demo_sonarqube.md
└── demo/
    └── sonarqube/
        ├── .env
        ├── .gitignore
        ├── docker-compose.yml
        ├── run-sonar.ps1
        └── sonar-project.properties
```

## Requisitos previos

- Docker y Docker Compose instalados.
- SonarScanner CLI instalado y disponible en el PATH del sistema.
- Una instancia de SonarQube (local mediante Docker o en la nube).
- Un token de autenticacion generado en SonarQube.
- Node.js (opcional, para ejecutar NodeGoat localmente si se desea).
- Cuenta y CLI de Snyk para la demo correspondiente.

## Instrucciones de ejecucion

### Demo de SonarQube (rama demo/sonarqube)

1. Cambiar a la rama de la demostracion:

   git checkout demo/sonarqube

2. Clonar el proyecto vulnerable OWASP NodeGoat dentro de la carpeta demo/sonarqube:

   git clone https://github.com/OWASP/NodeGoat.git demo/sonarqube/NodeGoat

3. Configurar el archivo de entorno:

   Editar demo/sonarqube/.env y establecer el valor de SONAR_TOKEN con el token generado en SonarQube (My Account > Security > Generate tokens).

4. Levantar SonarQube con Docker:

   cd demo/sonarqube
   docker-compose up -d

5. Ejecutar el analisis con el script de PowerShell:

   .\demo/sonarqube\run-sonar.ps1

   Desde una terminal de PowerShell con codificacion UTF-8 (ejecutar chcp 65001 si es necesario).

6. Acceder a los resultados:

   http://localhost:9000/dashboard?id=israel-startteam-nodegoat

### Demo de Snyk

1. Autenticar con Snyk:

   snyk auth

2. Ejecutar el analisis de codigo:

   snyk code test

3. O analizar dependencias:

   snyk test

## Configuracion externa requerida (no gestionable por IaC)

Algunos elementos no pueden automatizarse completamente mediante archivos de configuracion y requieren accion manual en la consola de cada herramienta:

- Generar el token de autenticacion de SonarQube en la interfaz web (My Account > Security > Generate tokens).
- Crear y configurar el proyecto en SonarQube si no se crea automaticamente al ejecutar el escaneo por primera vez.
- Cambiar la contrasena predeterminada de administrador de SonarQube (admin / admin) en el primer ingreso.
- Configurar una cuenta de Snyk y autenticarse con el CLI (snyk auth).

## Resultados esperados

El analisis de SonarQube sobre OWASP NodeGoat deberia identificar:

- Vulnerabilidades de inyeccion (A03) por uso de eval y consultas NoSQL.
- Fallos criptograficos (A02) por secretos y credenciales hardcodeados.
- Diseno inseguro (A04) por expresiones regulares vulnerables (ReDoS).
- Problemas de mantenibilidad y duplicacion de codigo.
- Cobertura de pruebas nula (0.0 por ciento).
- Quality gate fallido debido a cobertura insuficiente y duplicacion excesiva.

## Notas importantes

- El proyecto OWASP NodeGoat contiene vulnerabilidades intencionales con fines educativos. No debe usarse en entornos de produccion.
- El archivo .env contiene informacion sensible y no se versiona en el repositorio (esta incluido en .gitignore).
- La carpeta NodeGoat se clona localmente y tampoco se sube al repositorio git.

## Licencia

Uso educativo exclusivo para demostraciones de SAST.
