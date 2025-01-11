# Etapa de construcción
FROM bitnami/node:22.13.0-debian-12-r2 AS builder

# Configurar usuario root para la instalación
USER root
WORKDIR /app

# Creamos el usuario y grupo node si no existe
RUN groupadd -r node || true && \
    useradd -r -g node node || true

# Copiamos los archivos de dependencias
COPY package*.json ./

# Instalamos dependencias, incluyendo las de desarrollo para nodemon
RUN npm ci

# Copiamos el código fuente
COPY . .

# Aseguramos los permisos correctos
RUN chown -R 1001:1001 /app

# Etapa de producción
FROM bitnami/node:22.13.0-debian-12-r2 AS production

# Añadimos etiquetas útiles
LABEL maintainer="sandoval.morales.emmanuel@gmail.com"
LABEL version="1.0"
LABEL description="Express MongoDB CRUD Application"

# Establecemos el directorio de trabajo
WORKDIR /app

# Instalamos curl para el healthcheck
USER root
RUN apt-get update && apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Copiamos solo los archivos necesarios desde la etapa de builder
COPY --from=builder --chown=1001:1001 /app/package*.json ./
COPY --from=builder --chown=1001:1001 /app/node_modules ./node_modules
COPY --from=builder --chown=1001:1001 /app/src ./src

# Exponemos el puerto de la aplicación
EXPOSE 3001

# Configuramos el healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:3001/health || exit 1

# Usamos el usuario no root de Bitnami
USER 1001

# Comando para ejecutar la aplicación
CMD ["node", "src/index.js"]