# Guía de la Demo — SonarQube (OWASP NodeGoat)

Este documento explica paso a paso cómo levantar y analizar el proyecto **OWASP NodeGoat** con **SonarQube** y **SonarScanner**, dentro de la rama `demo/sonarqube`.

## 1. Proyecto de ejemplo

- **Nombre:** OWASP NodeGoat
- **Repositorio:** https://github.com/OWASP/NodeGoat
- **Lenguaje:** JavaScript (Node.js)
- **Framework:** Express
- **Base de datos:** MongoDB
- **Motivo:** contiene vulnerabilidades intencionales mapeadas al OWASP Top 10, errores evidentes y visibles, y falta de cobertura de pruebas.

## 2. Requisitos previos

- Docker y Docker Compose instalados.
- SonarScanner CLI instalado y disponible en el PATH.
- Acceso a una instancia de SonarQube (local vía Docker o en la nube).
- Un token de autenticación generado en SonarQube (ver sección de configuración externa).

## 3. Levantar SonarQube con Docker

Desde la carpeta `demo/sonarqube/`:

```bash
docker-compose up -d
```

Esto iniciará dos contenedores:
- `sonarqube-demo` en el puerto `http://localhost:9000`
- `sonarqube-db` (PostgreSQL) como base de datos interna de SonarQube

Espera a que SonarQube esté listo. Puedes verificar accediendo a:
```
http://localhost:9000
```

Credenciales por defecto (primer inicio):
- Usuario: `admin`
- Contraseña: `admin`

> Si Docker no funciona, puedes usar una instancia de SonarQube en la nube (SonarCloud) o instalar SonarQube manualmente y ajustar `sonar.host.url` en `sonar-project.properties`.

## 4. Generar el token de SonarQube

El token **no se puede configurar mediante IaC** porque se genera por usuario en la interfaz de SonarQube:

1. Inicia sesión en SonarQube (`http://localhost:9000`).
2. Ve a **My Account** → **Security**.
3. En **Generate tokens**, escribe un nombre (por ejemplo: `nodegoat-demo-token`) y pulsa **Generate**.
4. Copia el valor generado. Solo se muestra una vez.
5. Úsalo en el comando de SonarScanner como valor de `sonar.login`.

## 5. Ejecutar el análisis con SonarScanner

Desde la raíz del proyecto (o de la rama `demo/sonarqube`):

```bash
sonar-scanner \
  -Dsonar.projectKey=israel-startteam-nodegoat \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=<TU_TOKEN_AQUI>
```

Si prefieres usar el archivo de propiedades incluido:

```bash
sonar-scanner -Dsonar.login=<TU_TOKEN_AQUI>
```

SonarScanner subirá el reporte al servidor de SonarQube y podrás ver los resultados en la interfaz web.

## 6. Problemas que SonarQube debe identificar (según el reporte de vulnerabilidades)

Basado en las características de OWASP NodeGoat, SonarQube debe marcar:

| Problema | Ubicación aproximada | Categoría | Severidad esperada |
|----------|----------------------|-----------|--------------------|
| Uso de `eval()` con datos del usuario | `app/routes/contributions.js` | A03 Injection | Alta |
| Secretos hardcodeados (cookie secret, credenciales de BD) | `config/env/*.js` | A02 Cryptographic Failures | Alta |
| Inyección NoSQL en consultas a MongoDB | `app/data/*` | A03 Injection | Alta |
| Code smells y duplicación | Varios archivos | Mantenibilidad | Media |
| Cobertura de pruebas baja | Todo el proyecto | Calidad | Media |
| Expresión regular vulnerable (ReDoS) | Validaciones de perfil | A04 Insecure Design | Media |

> Algunas de estas vulnerabilidades también son detectables por Snyk Code, pero el enfoque de esta rama es el análisis con SonarQube.

## 7. Resultados del análisis

Una vez finalizado el escaneo, accede a SonarQube y busca el proyecto `israel-startteam-nodegoat`. Podrás revisar:

- **Quality Gate:** aprobado o fallido según los umbrales definidos.
- **Bugs y vulnerabilidades:** listado por archivo y línea.
- **Code smells:** problemas de mantenibilidad y duplicación.
- **Cobertura:** porcentaje de código cubierto por pruebas (esperado: bajo).
- **Hotspots:** zonas de código que requieren revisión de seguridad.

## 8. Notas

- El contenido de esta rama (`demo/sonarqube`) contiene únicamente los archivos de configuración para ejecutar la demo de SonarQube. El código vulnerable de OWASP NodeGoat se obtiene desde su repositorio original para el análisis.
- Algunos ajustes (token de usuario, creación del proyecto en SonarQube, credenciales de administrador) deben hacerse manualmente en la consola de SonarQube y no pueden automatizarse completamente con IaC.
