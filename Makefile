# Makefile para la plataforma docente Informática Industrial GIEIA
# El despliegue en GitHub Pages se realiza automáticamente mediante GitHub Actions.
# Ver .github/workflows/publish.yml

.PHONY: render preview serve clean

# Renderiza el sitio en _site/
render:
	quarto render

# Vista previa en local
preview:
	quarto preview

# Servidor estático sobre _site/ (tras renderizar)
serve:
	cd _site && python3 -m http.server 8000

# Limpia salidas de Quarto
clean:
	rm -rf _site .quarto
