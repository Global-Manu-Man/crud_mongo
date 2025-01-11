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

# Instalamos dependencias
RUN npm ci --only=production

# Copiamos el código fuente
COPY . .

# Si hay un paso de build, lo ejecutamos y configuramos permisos
RUN npm run build --if-present && \
    # Aseguramos los permisos correctos
    chown -R 1001:1001 /app

# Etapa de producción
FROM bitnami/node:22.13.0-debian-12-r2 AS production

# Añadimos etiquetas útiles
LABEL maintainer="developer@example.com"
LABEL version="1.0"
LABEL description="Aplicación Node.js en producción"

# Establecemos el directorio de trabajo
WORKDIR /app

# Copiamos los archivos necesarios desde la etapa de builder
COPY --from=builder --chown=1001:1001 /app/package*.json ./
COPY --from=builder --chown=1001:1001 /app/node_modules ./node_modules
COPY --from=builder --chown=1001:1001 /app/. .

# Exponemos el puerto que usará la aplicación
EXPOSE 3000

# Usamos el usuario no root de Bitnami
USER 1001

# Variables de entorno comunes en producción
ENV NODE_ENV=production \
    PORT=3000

# Comando para ejecutar la aplicación
CMD ["node", "src/index.js"]
