# SAST — IsraelStarTeam

Repositorio de demos prácticas de **SAST (Static Application Security Testing)** con **SonarQube** y **Snyk**. Incluye código con vulnerabilidades intencionales, guías de ejecución paso a paso, configuraciones de escaneo e integración con pipelines de CI/CD.

## Estructura del repositorio

```
SAST-IsraelStarTeam/
├── README.md                      # Documentación base (este archivo)
├── docs/                          # Diapositivas y documentación de la presentación
│   ├── conceptos.md
│   ├── importancia.md
│   ├── herramientas-sast.md       # Cuadro comparativo de herramientas SAST
│   └── sdlc-etapa.md              # Etapa del proceso SDLC donde aplica SAST
├── demo/                          # Proyecto vulnerable de ejemplo para analizar
│   ├── sonarqube/                 # Demo específica de SonarQube (rama demo/sonarqube)
│   └── snyk/                      # Demo específica de Snyk
├── sonar-project.properties       # Configuración de SonarScanner (IaC)
├── .snyk                          # Configuración de Snyk (IaC)
├── docker-compose.yml             # Orquestación local de SonarQube (IaC)
└── .github/workflows/             # Pipelines de CI/CD (GitHub Actions)
```

## Demos incluidas

| Demo | Herramienta | Rama | Descripción |
|------|-------------|------|-------------|
| SonarQube | SonarQube + SonarScanner | `demo/sonarqube` | Análisis estático de calidad, bugs, vulnerabilidades y code smells |
| Snyk | Snyk Code / Snyk CLI | `main` (o rama dedicada) | Detección de vulnerabilidades en código y dependencias |

## Requisitos previos

- Docker y Docker Compose (para levantar SonarQube localmente)
- Node.js / Java / Python (según el lenguaje del proyecto demo)
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

Consulta `docs/` para ver las diapositivas con capturas del paso a paso y los resultados del análisis.

### Demo de Snyk

```bash
snyk auth
snyk code test
# o
snyk test
```

## Notas importantes

- El proyecto de demo contiene **vulnerabilidades intencionales** y **falta de cobertura de pruebas** para que ambas herramientas las identifiquen con errores obvios y visibles.
- Algunas configuraciones no pueden gestionarse mediante IaC y deben hacerse manualmente en la consola de cada herramienta (ver sección de configuración externa en la documentación de cada demo).

## Licencia

Educativo — uso exclusivo para demos de SAST.
