# AGENTS.md

Plataforma docente interactiva para **Informática Industrial** del Grado en Ingeniería Electrónica Industrial y Automática (UCLM, EIIA-Toledo). Sigue la misma filosofía y stack que el repositorio hermano `informatica-gia` (Grado en Ingeniería Aeroespacial), adaptado a esta asignatura. Contenido en español.

## Estado actual

- Repo en `main` con el **esqueleto de la plataforma ya montado** (sin commits aún). Remote: `github.com/DavidMunozValero/informatica-industrial-gieia`.
- Plataforma Quarto operativa (replicada de `../informatica-gia`): `_quarto.yml`, `index.qmd`, `styles/custom-v2.css`, `styles/playground-loader.html`, `widgets/*.html`, `images/`, `favicon.svg`, `Makefile`, `.github/workflows/publish.yml`, `.gitignore`. `main.py` (boilerplate PyCharm) eliminado.
- **Sin temas todavía:** `index.qmd` muestra la portada con tarjetas `(Próximamente)` por bloques; el sidebar lista los temas como texto plano (sin `href`). Al crear un tema: añadir `temaX.qmd`, registrarlo en `render:` de `_quarto.yml` y darle `href` en el sidebar.
- **Requisito local:** Quarto CLI >= 1.4.557 (NO está instalado en esta máquina). No hace falta venv Python: el único uso de Python es `make serve` (`python3 -m http.server`, stdlib sin dependencias).
- `contenidos/` ≈ 67 MB de material fuente sin procesar (≈43 PDF, ≈23 ZIP, 4 `.ino`, 1 `.py`). **Fuera de git** (ver `.gitignore`); materia prima local para construir los temas.

## Referencia autoritativa

El repositorio adyacente `../informatica-gia` es el **modelo a replicar**. Su `AGENTS.md` y `README.md` son la guía de estilo autoritativa (estructura de temas, taxonomía de callouts, paleta, convenciones de widgets, voz/tono, filosofía docente). Consultarlos antes de crear contenido; este archivo no la duplica, solo fija el esqueleto y las decisiones propias de este repo.

## Higiene del repo (entorno sanitizado)

Antes del primer commit, establecer `.gitignore` (base copiable de `../informatica-gia/.gitignore`):
- Excluir `.DS_Store`, `.idea/`, `.vscode/`, `venv/`, `*.log`, `*.tmp`.
- Excluir salida Quarto: `/_site/`, `/.quarto/`.
- **`contenidos/` fuera de git**: son 67 MB de binarios fuente. Mantener en local como material de partida; si se necesitan en el repo, usar Git LFS o un repo aparte. No volcarlos al historial normal.
- Eliminar `main.py` (boilerplate PyCharm) — no forma parte de la plataforma.

## Arquitectura objetivo (replicar `informatica-gia`)

Stack: **Quarto 1.4.557** + GitHub Pages. Estructura a crear:

- `_quarto.yml` — config del sitio (navbar con logo UCLM, sidebar por bloques, `format.html` con tema `cosmo`, `lang: es`, `toc-depth: 3`, CSS e `include-after-body` del playground-loader).
- `index.qmd` — portada con tarjetas de navegación (`card-nav`) por bloques temáticos.
- `tema*.qmd` — un `.qmd` por tema. **Fuente de verdad del contenido.**
- `styles/custom-v2.css` — única hoja manual; el sufijo `-v2` es **cache-busting** deliberado (heredado). Al renombrar, actualizar el `<link>` en `_quarto.yml` y forzar recarga.
- `styles/playground-loader.html` — inyecta código de `pre.pg-code` en iframes del playground Python; se incluye vía `include-after-body`.
- `widgets/*.html` — widgets autocontenidos embebidos por `<iframe src="widgets/..." title="...">`. Mover/renombrar un widget rompe los `src` de los temas.
- `images/` — logos institucionales; `favicon.svg`.
- `Makefile` — targets `render`/`preview`/`serve`/`clean` (idéntico al de referencia).
- `.github/workflows/publish.yml` — CI/CD a GitHub Pages.

**Generados por Quarto (no editar a mano):** `_site/`, `.quarto/`, `site_libs/` (bootstrap, mermaid, tippy, clipboard, search — vendoring), los `*.html` raíz y `search.json`. Editar siempre los `.qmd`/`_quarto.yml` y regenerar con `quarto render`.

## Comandos

```
quarto render        # genera _site/
quarto preview       # vista previa con recarga
make serve           # sirve _site/ en :8000 (python3 -m http.server)
make clean           # borra _site/ y .quarto/
```

Requisito: Quarto >= 1.4.557 instalado localmente. Instalación en macOS: `brew install --cask quarto` (última) o descargar el dmg de la versión pinneada 1.4.557 desde https://quarto.org/download/. Verificar con `quarto check`. No se necesita venv: Python solo se usa para `make serve` (stdlib).

## Despliegue (GitHub Pages)

- Workflow `.github/workflows/publish.yml`: en `push` a `main`, instala Quarto 1.4.557 (versión **pinneada**), renderiza y despliega `_site/` con `actions/deploy-pages`.
- Config requerida en GitHub: **Settings → Pages → Source = GitHub Actions**; **Settings → Actions → General → Workflow permissions = Read and write** (lo exige `deploy-pages`).
- Flujo de publicación: editar `.qmd`/`_quarto.yml` → `quarto render` + revisar local → commit y push a `main`.

## Convenciones heredadas (resumen; ver `../informatica-gia/AGENTS.md` para detalle)

- **Paleta UCLM:** granate `#8B1D2B` (líneas/bordes), `#6B0E1A` (texto), `#F5E6E8` (fondos suaves), oro `#C9A227`. Mermaid: tema `default` con estas variables inline.
- **Callouts:** `note` (definiciones/datos), `tip` (ampliaciones/casos reales), `warning` (errores comunes/precisiones), `example` (ejemplos resueltos), `exercise` (enunciados).
- **Widgets:** `<iframe>` con `title`, `scrolling="no"`, altura adecuada, ruta relativa `widgets/<name>.html`.
- **Playground Python:** Pyodide **v0.26.4** (CDN jsdelivr) + CodeMirror **5.65.16** (CDN cloudflare). Cambiar versiones rompe el widget; verificar `runPython` tras actualizar y considerar añadir `integrity`.
- **Seguridad:** `postMessage` solo al origen calculado del `iframe.src` (nunca `'*'`); el playground rechaza `event.origin` ajeno; validar todo código entrante por URL.
- **Voz:** español de España, *tú* al alumno; 1.ª p. plural en explicaciones, 2.ª en actividades.

## Verificación

No hay tests ni lint. Validar un cambio:
- `quarto render` y servir `_site/` (`make serve`).
- Comprobar que los `<iframe>` de widgets cargan (Pyodide tarda varios segundos la 1.ª vez; necesita conexión a CDN).
- Revisar diagramas Mermaid centrados, logo en cabecera y búsqueda lateral.
