# Explicacion de la demo de SonarQube

Este documento describe como se realizo la demostracion de analisis estatico de codigo con SonarQube sobre el proyecto OWASP NodeGoat. Incluye los pasos de ejecucion, lo que detecto la herramienta y un hallazgo importante sobre el comportamiento del Quality Gate que resulta util para entender como funciona SAST en la práctica.

## 1. Caracteristicas de SonarQube

SonarQube es una plataforma de inspeccion continua de la calidad del codigo. Sus principales características son:

- Analisis estatico de codigo fuente sin ejecutar la aplicacion.
- Deteccion de bugs, vulnerabilidades de seguridad y code smells.
- Medicion de cobertura de pruebas.
- Deteccion de duplicacion de codigo (CPD).
- Evaluacion de mantenibilidad y deuda tecnica.
- Quality Gates para permitir o bloquear despliegues segun umbrales definidos.
- Integracion con repositorios de codigo y pipelines de CI/CD.
- Paneles visuales con metricas historicas.
- Soporte para multiples lenguajes, incluido JavaScript.

## 2. Funcionalidades

- Analisis de calidad de codigo fuente.
- Analisis de seguridad estatico (SAST).
- Analisis de cobertura de pruebas.
- Deteccion de duplicaciones.
- Asignacion de severidad a los problemas (Bloqueador, Critico, Mayor, Menor, Informativo).
- Historico de analisis por version del proyecto.
- Integracion con IDE mediante SonarLint.
- Integracion con plataformas de control de versiones (GitHub, GitLab, Bitbucket, Azure DevOps).

## 3. Como se ejecuta la demo

La demostracion analiza el proyecto OWASP NodeGoat, una aplicacion vulnerable de ejemplo, usando SonarQube desplegado localmente con Docker.

Paso a paso:

1. Clonar OWASP NodeGoat dentro de la carpeta demo/sonarqube/NodeGoat:

   git clone https://github.com/OWASP/NodeGoat.git demo/sonarqube/NodeGoat

2. Levantar SonarQube con Docker Compose:

   cd demo/sonarqube
   docker-compose up -d

3. Generar un token de autenticacion en SonarQube (My Account > Security > Generate tokens).

4. Configurar el archivo demo/sonarqube/.env con el token (SONAR_TOKEN).

5. Ejecutar el script de analisis desde PowerShell:

   .\demo/sonarqube\run-sonar.ps1

   (Previamente ejecutar chcp 65001 si la consola no muestra correctamente los acentos).

6. Acceder a la interfaz web de SonarQube en http://localhost:9000 para revisar los resultados.

## 4. Que detecto SonarQube en NodeGoat

El proyecto OWASP NodeGoat contiene vulnerabilidades intencionales. La tabla a continuacion muestra lo que SonarQube identifico:

| Vulnerabilidad esperada | Ubicacion aproximada en NodeGoat | Como lo detecto SonarQube |
|-------------------------|----------------------------------|---------------------------|
| Uso de eval() con datos de usuario (inyeccion de codigo) | app/routes/contributions.js | El sensor de JavaScript identifica llamadas a eval() con entrada no sanitizada como posible inyeccion de codigo (A03 Injection). |
| Secretos hardcodeados (cookie secret, credenciales de BD) | config/env/*.js | El sensor TextAndSecrets detecta cadenas que parecen claves, tokens o contrasenas escritas directamente en el codigo. |
| Inyeccion NoSQL en consultas a MongoDB | app/data/* | El analisis de patrones de consulta a base de datos identifica construccion de consultas NoSQL a partir de entrada de usuario sin validar (A03 Injection). |
| Expresion regular vulnerable (ReDoS) | Validaciones de perfil | SonarQube identifica expresiones regulares con riesgo de denegacion de servicio por retrocencion catastrofica (A04 Insecure Design). |
| Code smells y duplicacion | Varios archivos | Los sensores de mantenibilidad detectan codigo duplicado, funciones largas y malas practicas de programacion. |
| Cobertura de pruebas baja | Todo el proyecto | La integracion con reportes de cobertura muestra 0.0 por ciento de cobertura. |

## 5. Hallazgo sobre el Quality Gate

Durante la demo se observe un comportamiento importante del Quality Gate que hay que tener en cuenta:

Por defecto, el quality gate de SonarQube (Sonar way) evalua principalmente el **New Code** (codigo nuevo desde una fecha de referencia), no el **Overall Code** (todo el proyecto). En este caso, al ser el primer analisis y no haber cambios nuevos despues de la linea base, el gate reporte cero issues en codigo nuevo y marco el estado como **Passed**, a pesar de que el proyecto completo tuviera 29 issues, 0.0 por ciento de cobertura y 6.9 por ciento de duplicacion.

Esto significa que un proyecto con problemas graves puede pasar desapercibido si el quality gate solo mide codigo nuevo. Para que el gate falle con las metricas actuales de NodeGoat, es necesario crear un quality gate personalizado que evalue el Overall Code con las siguientes condiciones:

- Coverage is less than 80.0%
- Duplicated Lines is greater than 3.0%
- Reliability Rating is worse than C
- Security Rating is worse than C

Con estas condiciones, el Quality Gate pasara a **Failed** y se podra demostrar como SAST funciona como una puerta de calidad real en el SDLC.

## 6. Integracion con un repositorio

SonarQube se integra con un repositorio de codigo de las siguientes formas:

- Analisis manual: un desarrollador ejecuta SonarScanner localmente apuntando al repositorio clonado.
- Analisis en CI/CD: se configura un pipeline (por ejemplo GitHub Actions) que clona el repositorio, ejecuta SonarScanner y sube los resultados a SonarQube.
- Webhooks: SonarQube puede notificar al repositorio cuando finaliza un analisis para actualizar estados de pull requests.
- Quality Gates: se definen umbrales (por ejemplo, cobertura minima, cero vulnerabilidades bloqueadoras) que deben cumplirse para considerar el codigo apto para fusionar o desplegar.
- SonarLint: extensiones para IDE que se conectan a SonarQube y muestran problemas en tiempo real mientras se escribe codigo en el repositorio local.

## 7. Resultados obtenidos en la demo

Al ejecutar el analisis sobre OWASP NodeGoat, SonarQube reporte lo siguiente:

- Quality Gate: Passed (por defecto, porque mide New Code y no hubo cambios nuevos).
- 29 issues abiertos en total en el Overall Code.
- 15 issues de seguridad.
- 14 issues de confiabilidad.
- 15 issues de mantenibilidad.
- Cobertura de pruebas: 0.0 por ciento.
- Duplicacion de codigo: 6.87 por ciento.

Estos resultados confirman que SonarQube identifico los problemas esperados en el proyecto vulnerable. El hecho de que el Quality Gate haya pasado resalta la importancia de configurar correctamente las condiciones de evaluacion, ya que de lo contrario el analisis puede no reflejar el estado real del codigo.

## 8. Consideraciones finales

El proyecto OWASP NodeGoat contiene vulnerabilidades intencionales con fines educativos. No debe usarse en entornos de produccion. El archivo .env contiene informacion sensible y no se versiona en el repositorio (esta incluido en .gitignore). La carpeta NodeGoat se clona localmente y tampoco se sube al repositorio git.
