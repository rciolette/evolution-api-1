version: '3.8'

services:
  api:
    container_name: evolution_api
    image: evoapicloud/evolution-api:latest
    restart: always
    depends_on:
      - redis
      - postgres
    ports:
      - 8082:8082
    volumes:
      - evolution_instances:/evolution/instances
      - /etc/letsencrypt:/etc/letsencrypt:ro
    networks:
      - evolution-net
    env_file:
      - .env
    expose:
      - 8082

  redis:
    image: redis:7-alpine
    restart: always
    networks:
      - evolution-net

  postgres:
    image: postgres:15-alpine
    restart: always
    environment:
      POSTGRES_DB: evolution
      POSTGRES_USER: evolution
      POSTGRES_PASSWORD: evolution
    volumes:
      - evolution_data:/var/lib/postgresql/data
    networks:
      - evolution-net

  nginx:
    image: nginx:alpine
    restart: always
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
    networks:
      - evolution-net

networks:
  evolution-net:

volumes:
  evolution_instances:
  evolution_data:
