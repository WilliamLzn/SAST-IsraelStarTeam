# SAST — IsraelStarTeam

Repositorio de demos prácticas de **SAST (Static Application Security Testing)** con **SonarQube** y **Snyk**. Incluye código con vulnerabilidades intencionales, guías de ejecución paso a paso, configuraciones de escaneo e integración con pipelines de CI/CD.

## Proyecto de demostración

Se utiliza **OWASP NodeGoat** como proyecto vulnerable de ejemplo:

- Repositorio: https://github.com/OWASP/NodeGoat
- Lenguaje: JavaScript (Node.js)
- Framework: Express
- Base de datos: MongoDB
- Tipo de app: Gestión de ahorros para el retiro

OWASP NodeGoat contiene vulnerabilidades intencionales mapeadas al OWASP Top 10, con errores evidentes y visibles, así como falta de cobertura de pruebas, lo que lo hace ideal para demostrar el análisis estático con SonarQube y Snyk.

## Estructura del repositorio

```
SAST-IsraelStarTeam/
├── README.md                          # Documentación base (este archivo)
├── docs/                              # Documentación explicativa de las demos
│   ├── demo_sonarqube.md              # Guía de la demo de SonarQube
│   └── demo_snyk.md                   # Guía de la demo de Snyk
├── demo/sonarqube/                    # Archivos de configuración para la demo de SonarQube
│   ├── sonar-project.properties       # Configuración de SonarScanner
│   └── docker-compose.yml             # Orquestación local de SonarQube
├── sonar-project.properties           # Configuración de SonarScanner (IaC)
├── .snyk                              # Configuración de Snyk (IaC)
├── docker-compose.yml                 # Orquestación local de SonarQube (IaC)
└── .github/workflows/                 # Pipelines de CI/CD (GitHub Actions)
```

## Demos incluidas

| Demo | Herramienta | Rama | Descripción |
|------|-------------|------|-------------|
| SonarQube | SonarQube + SonarScanner | `demo/sonarqube` | Análisis estático de calidad, bugs, vulnerabilidades y code smells sobre OWASP NodeGoat |
| Snyk | Snyk Code / Snyk CLI | `main` | Detección de vulnerabilidades en código y dependencias |

## Requisitos previos

- Docker y Docker Compose (para levantar SonarQube localmente)
- Node.js (para ejecutar OWASP NodeGoat)
- SonarScanner CLI
- Cuenta y CLI de Snyk (`snyk auth`)
- Cuenta en SonarQube (local o en la nube)

## Cómo ejecutar las demos

### Demo de SonarQube (rama `demo/sonarqube`)

```bash
# Cambiar a la rama de la demo
git checkout demo/sonarqube

# Levantar SonarQube con Docker Compose
docker-compose up -d

# Ejecutar el análisis con SonarScanner
sonar-scanner -Dsonar.projectKey=israel-startteam-demo \
              -Dsonar.sources=. \
              -Dsonar.host.url=http://localhost:9000 \
              -Dsonar.login=<TOKEN_DE_SONARQUBE>
```

Consulta `docs/demo_sonarqube.md` para ver la guía paso a paso y los resultados del análisis.

### Demo de Snyk

```bash
snyk auth
snyk code test
# o
snyk test
```

## Notas importantes

- El proyecto de demo contiene **vulnerabilidades intencionales** y **falta de cobertura de pruebas** para que ambas herramientas las identifiquen con errores obvios y visibles.
- Algunas configuraciones no pueden gestionarse mediante IaC y deben hacerse manualmente en la consola de cada herramienta (ver documentación de cada demo).

## Licencia

Educativo — uso exclusivo para demos de SAST.
