terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
}


resource "docker_network" "supabase_network" {
  name = "supabase_network"
}

resource "docker_volume" "db_config" {
  name = "db-config"
}

resource "docker_volume" "weaviate_data" {
  name = "weaviate_data"
}

# Line 12
resource "docker_image" "supabase_studio" {
  name = "supabase/studio:20241014-c083b3b"
  keep_locally = true
}

resource "docker_image" "kong" {
  name = "kong:2.8.1"
  keep_locally = true
}

resource "docker_image" "gotrue" {
  name = "supabase/gotrue:v2.158.1"
  keep_locally = true
}

resource "docker_image" "postgrest" {
  name = "postgrest/postgrest:v12.2.0"
  keep_locally = true
}

resource "docker_image" "realtime" {
  name = "supabase/realtime:v2.30.34"
  keep_locally = true
}

resource "docker_image" "storage_api" {
  name = "supabase/storage-api:v1.11.13"
  keep_locally = true
}

resource "docker_image" "imgproxy" {
  name = "darthsim/imgproxy:v3.8.0"
  keep_locally = true
}

resource "docker_image" "postgres_meta" {
  name = "supabase/postgres-meta:v0.84.2"
  keep_locally = true
}

resource "docker_image" "edge_runtime" {
  name = "supabase/edge-runtime:v1.59.0"
  keep_locally = true
}

resource "docker_image" "logflare" {
  name = "supabase/logflare:1.4.0"
  keep_locally = true
}

resource "docker_image" "postgres" {
  name = "supabase/postgres:15.1.1.78"
  keep_locally = true
}

resource "docker_image" "vector" {
  name = "timberio/vector:0.28.1-alpine"
  keep_locally = true
}

resource "docker_image" "supavisor" {
  name = "supabase/supavisor:1.1.56"
  keep_locally = true
}

resource "docker_image" "weaviate" {
  name = "cr.weaviate.io/semitechnologies/weaviate:1.27.1"
  keep_locally = true
}

resource "docker_image" "img2vec" {
  name = "cr.weaviate.io/semitechnologies/img2vec-keras:resnet50"
  keep_locally = true
}

resource "docker_image" "caddy" {
  name = "caddy:2"
  keep_locally = true
}

resource "docker_image" "webui" {
  name = "dyrnq/open-webui:main"
  keep_locally = true
}

resource "docker_container" "studio" {
  name    = "studio"
  image   = docker_image.supabase_studio.image_id
  restart = "unless-stopped"
  healthcheck {
    test = [
      "CMD",
      "node",
      "-e",
      "require('http').get('http://localhost:3000/api/profile', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"
    ]
    interval = "5s"
    timeout  = "5s"
    retries  = 3
  }

  env = [
    "STUDIO_PG_META_URL=http://meta:8080",
    "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}",
    "DEFAULT_ORGANIZATION_NAME=${STUDIO_DEFAULT_ORGANIZATION}",
    "DEFAULT_PROJECT_NAME=${STUDIO_DEFAULT_PROJECT}",
    "OPENAI_API_KEY=${OPENAI_API_KEY}",
    "OPENAI_API_KEY=",
    "SUPABASE_URL=http://kong:8000",
    "SUPABASE_PUBLIC_URL=${SUPABASE_PUBLIC_URL}",
    "SUPABASE_ANON_KEY=${ANON_KEY}",
    "SUPABASE_SERVICE_KEY=${SERVICE_ROLE_KEY}",
    "AUTH_JWT_SECRET=${JWT_SECRET}",
    "LOGFLARE_API_KEY=${LOGFLARE_API_KEY}",
    "LOGFLARE_URL=http://analytics:4000",
    "NEXT_PUBLIC_ENABLE_LOGS=true",
    "NEXT_ANALYTICS_BACKEND_PROVIDER=postgress"
  ]

  
  depends_on = [docker_container.analytics]

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "kong" {
  name    = "kong"
  image   = docker_image.kong.image_id
  restart = "unless-stopped"
  entrypoint = ["bash", "-c", "eval \"echo \\\"$$(cat ~/temp.yml)\\\"\" > ~/kong.yml && /docker-entrypoint.sh kong docker-start"]
  ports {
    internal = 8000
    external = "${KONG_HTTP_PORT}"
    protocol = "tcp"
  }

  ports {
    internal = 8443
    external = "${KONG_HTTPS_PORT}"
    protocol = "tcp"
  }

  env = [
    "KONG_DATABASE=off",
    "KONG_DECLARATIVE_CONFIG=/var/lib/kong/kong.yml",
    "KONG_DNS_ORDER=LAST,A,CNAME",
    "KONG_PLUGINS=request-transformer,cors,key-auth,acl,basic-auth",
    "KONG_NGINX_PROXY_PROXY_BUFFER_SIZE=160k",
    "KONG_NGINX_PROXY_PROXY_BUFFERS=64 160k",
    "SUPABASE_ANON_KEY=${ANON_KEY}",
    "SUPABASE_SERVICE_KEY=${SERVICE_ROLE_KEY}",
    "DASHBOARD_USERNAME=${DASHBOARD_USERNAME}",
    "DASHBOARD_PASSWORD=${DASHBOARD_PASSWORD}"
  ]

  mounts {
    type = "bind"
    target = "/home/kong/temp.yml"
    source = "${WORKING_DIRECTORY}/volumes/api/kong.yml"
    read_only= true
  }

  mounts {
    type = "bind"
    target = "/var/lib/kong"
    source = "${WORKING_DIRECTORY}/volumes/api"
    read_only= true
  }

  

  depends_on = [docker_container.analytics]

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "auth" {
  name    = "auth"
  image   = docker_image.gotrue.image_id
  restart = "unless-stopped"

  healthcheck {
    test = [
      "CMD",
      "wget",
      "--no-verbose",
      "--tries=1",
      "--spider",
      "http://localhost:9999/health"
    ]
    interval = "5s"
    timeout  = "5s"
    retries  = 3
  }
  

  env = [
    "GOTRUE_API_HOST=0.0.0.0",
    "GOTRUE_API_PORT=9999",
    "API_EXTERNAL_URL=${API_EXTERNAL_URL}",
    "GOTRUE_DB_DRIVER=postgres",
    "GOTRUE_DB_DATABASE_URL=postgres://supabase_auth_admin:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}",
    "GOTRUE_SITE_URL=${SITE_URL}",
    "GOTRUE_URI_ALLOW_LIST=${ADDITIONAL_REDIRECT_URLS}",
    "GOTRUE_DISABLE_SIGNUP=${DISABLE_SIGNUP}",
    "GOTRUE_JWT_ADMIN_ROLES=service_role",
    "GOTRUE_JWT_AUD=authenticated",
    "GOTRUE_JWT_DEFAULT_GROUP_NAME=authenticated",
    "GOTRUE_JWT_EXP=${JWT_EXPIRY}",
    "GOTRUE_JWT_SECRET=${JWT_SECRET}",
    "GOTRUE_EXTERNAL_EMAIL_ENABLED=${ENABLE_EMAIL_SIGNUP}",
    "GOTRUE_EXTERNAL_ANONYMOUS_USERS_ENABLED=${ENABLE_ANONYMOUS_USERS}",
    "GOTRUE_MAILER_AUTOCONFIRM=${ENABLE_EMAIL_AUTOCONFIRM}",
    "GOTRUE_SMTP_ADMIN_EMAIL=${SMTP_ADMIN_EMAIL}",
    "GOTRUE_SMTP_HOST=${SMTP_HOST}",
    "GOTRUE_SMTP_PORT=${SMTP_PORT}",
    "GOTRUE_SMTP_USER=${SMTP_USER}",
    "GOTRUE_SMTP_PASS=${SMTP_PASS}",
    "GOTRUE_SMTP_SENDER_NAME=${SMTP_SENDER_NAME}",
    "GOTRUE_MAILER_URLPATHS_INVITE=${MAILER_URLPATHS_INVITE}",
    "GOTRUE_MAILER_URLPATHS_CONFIRMATION=${MAILER_URLPATHS_CONFIRMATION}",
    "GOTRUE_MAILER_URLPATHS_RECOVERY=${MAILER_URLPATHS_RECOVERY}",
    "GOTRUE_MAILER_URLPATHS_EMAIL_CHANGE=${MAILER_URLPATHS_EMAIL_CHANGE}",
    "GOTRUE_EXTERNAL_PHONE_ENABLED=${ENABLE_PHONE_SIGNUP}",
    "GOTRUE_SMS_AUTOCONFIRM=${ENABLE_PHONE_AUTOCONFIRM}"
  ]

  depends_on = [docker_container.db, docker_container.analytics]

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "rest" {
  name    = "rest"
  image   = docker_image.postgrest.image_id
  restart = "unless-stopped"
  command = ["postgrest"]
  env = [
    "PGRST_DB_URI=postgres://authenticator:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}",
    "PGRST_DB_SCHEMAS=${PGRST_DB_SCHEMAS}",
    "PGRST_DB_ANON_ROLE=anon",
    "PGRST_JWT_SECRET=${JWT_SECRET}",
    "PGRST_DB_USE_LEGACY_GUCS=false",
    "PGRST_APP_SETTINGS_JWT_SECRET=${JWT_SECRET}",
    "PGRST_APP_SETTINGS_JWT_EXP=${JWT_EXPIRY}"
  ]
  

  depends_on = [docker_container.db, docker_container.analytics]

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "realtime" {
  name    = "realtime"
  image   = docker_image.realtime.image_id
  restart = "unless-stopped"

  healthcheck {
    test = [
      "CMD",
      "curl",
      "-sSfL",
      "--head",
      "-o",
      "/dev/null",
      "-H",
      "Authorization: Bearer ${ANON_KEY}",
      "http://localhost:4000/api/tenants/realtime-dev/health"
    ]
    interval = "5s"
    timeout  = "5s"
    retries  = 3
  }

  env = [
    "PORT=4000",
    "DB_HOST=${POSTGRES_HOST}",
    "DB_PORT=${POSTGRES_PORT}",
    "DB_USER=supabase_admin",
    "DB_PASSWORD=${POSTGRES_PASSWORD}",
    "DB_NAME=${POSTGRES_DB}",
    "DB_AFTER_CONNECT_QUERY='SET search_path TO _realtime'",
    "DB_ENC_KEY=supabaserealtime",
    "API_JWT_SECRET=${JWT_SECRET}",
    "SECRET_KEY_BASE=UpNVntn3cDxHJpq99YMc1T1AQgQpc8kfYTuRgBiYa15BLrx8etQoXz3gZv1/u2oq",
    "ERL_AFLAGS=-proto_dist inet_tcp",
    "DNS_NODES=''",
    "RLIMIT_NOFILE=10000",
    "APP_NAME=realtime",
    "SEED_SELF_HOST=true",
  ]

  

  depends_on = [docker_container.db, docker_container.analytics]

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "storage" {
  name    = "storage"
  image   = docker_image.storage_api.image_id
  restart = "unless-stopped"
  

  healthcheck {
    test = [
      "CMD",
      "wget",
      "--no-verbose",
      "--tries=1",
      "--spider",
      "http://localhost:5000/status"
    ]
    interval = "5s"
    timeout  = "5s"
    retries  = 3
  }

  env = [
    "ANON_KEY=${ANON_KEY}",
    "SERVICE_KEY=${SERVICE_ROLE_KEY}",
    "POSTGREST_URL=http://rest:3000",
    "PGRST_JWT_SECRET=${JWT_SECRET}",
    "DATABASE_URL=postgres://supabase_storage_admin:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}",
    "FILE_SIZE_LIMIT=52428800",
    "STORAGE_BACKEND=file",
    "FILE_STORAGE_BACKEND_PATH=/var/lib/storage",
    "TENANT_ID=stub",
    "REGION=stub",
    "GLOBAL_S3_BUCKET=stub",
    "ENABLE_IMAGE_TRANSFORMATION=true",
    "IMGPROXY_URL=http://imgproxy:5001"
  ]

  volumes {
    container_path = "/var/lib/storage"
    host_path      = "${WORKING_DIRECTORY}/volumes/storage"
    #
  }

  depends_on = [docker_container.db, docker_container.rest, docker_container.imgproxy]

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "imgproxy" {
  name    = "imgproxy"
  image   = docker_image.imgproxy.image_id
  restart = "unless-stopped"
  

  healthcheck {
    test = [
      "CMD",
      "imgproxy",
      "health"
    ]
    interval = "5s"
    timeout  = "5s"
    retries  = 3
  }

  env = [
    "IMGPROXY_BIND=:5001",
    "IMGPROXY_LOCAL_FILESYSTEM_ROOT=/",
    "IMGPROXY_USE_ETAG=true",
    "IMGPROXY_ENABLE_WEBP_DETECTION=${IMGPROXY_ENABLE_WEBP_DETECTION}"
  ]

  volumes {
    container_path = "/var/lib/storage"
    host_path      = "${WORKING_DIRECTORY}/volumes/storage"
    #
  }
  

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "meta" {
  name    = "meta"
  image   = docker_image.postgres_meta.image_id
  restart = "unless-stopped"

  env = [
    "PG_META_PORT=8080",
    "PG_META_DB_HOST=${POSTGRES_HOST}",
    "PG_META_DB_PORT=${POSTGRES_PORT}",
    "PG_META_DB_NAME=${POSTGRES_DB}",
    "PG_META_DB_USER=supabase_admin",
    "PG_META_DB_PASSWORD=${POSTGRES_PASSWORD}"
  ]

  depends_on = [docker_container.db, docker_container.analytics]

  

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "functions" {
  name    = "functions"
  image   = docker_image.edge_runtime.image_id
  restart = "unless-stopped"

  command = ["start", "--main-service", "/home/deno/functions/main"]

  env = [
    "JWT_SECRET=${JWT_SECRET}",
    "SUPABASE_URL=http://kong:8000",
    "SUPABASE_ANON_KEY=${ANON_KEY}",
    "SUPABASE_SERVICE_ROLE_KEY=${SERVICE_ROLE_KEY}",
    "SUPABASE_DB_URL=postgresql://postgres:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}",
    "VERIFY_JWT=${FUNCTIONS_VERIFY_JWT}"
  ]

  volumes {
    container_path = "/home/deno/functions"
    host_path      = "${WORKING_DIRECTORY}/volumes/functions"
    #
  }

  depends_on = [docker_container.analytics]
  

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "analytics" {
  name    = "analytics"
  image   = docker_image.logflare.image_id
  restart = "unless-stopped"

  healthcheck {
    test = [
      "CMD",
      "curl",
      "http://localhost:4000/health"
    ]
    interval = "5s"
    timeout  = "5s"
    retries  = 10
  }

  ports {
    internal = 4000
    external = 4000
    protocol = "tcp"
  }


  env = [
    "LOGFLARE_NODE_HOST=127.0.0.1",
    "DB_USERNAME=supabase_admin",
    "DB_DATABASE=_supabase",
    "DB_HOSTNAME=${POSTGRES_HOST}",
    "DB_PORT=${POSTGRES_PORT}",
    "DB_PASSWORD=${POSTGRES_PASSWORD}",
    "DB_SCHEMA=_analytics",
    "LOGFLARE_API_KEY=${LOGFLARE_API_KEY}",
    "LOGFLARE_SINGLE_TENANT=true",
    "LOGFLARE_SUPABASE_MODE=true",
    "LOGFLARE_MIN_CLUSTER_SIZE=1",
    "POSTGRES_BACKEND_URL=postgresql://supabase_admin:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/_supabase",
    "POSTGRES_BACKEND_SCHEMA=_analytics",
    "LOGFLARE_FEATURE_FLAG_OVERRIDE=multibackend=true"
  ]

  depends_on = [docker_container.db]
  

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "db" {
  name    = "db"
  image   = docker_image.postgres.image_id
  restart = "unless-stopped"
  

  healthcheck {
    test = [
      "pg_isready",
      "-U",
      "postgres",
      "-h",
      "localhost",
    ]
    interval = "5s"
    timeout  = "5s"
    retries  = 10
  }

  command = [
    "postgres",
    "-c",
    "config_file=/etc/postgresql/postgresql.conf",
    "-c",
    "log_min_messages=fatal"
  ]

  env = [
    "POSTGRES_HOST=/var/run/postgresql",
    "PGPORT=${POSTGRES_PORT}",
    "POSTGRES_PORT=${POSTGRES_PORT}",
    "PGPASSWORD=${POSTGRES_PASSWORD}",
    "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}",
    "PGDATABASE=${POSTGRES_DB}",
    "POSTGRES_DB=${POSTGRES_DB}",
    "JWT_SECRET=${JWT_SECRET}",
    "JWT_EXP=${JWT_EXPIRY}"
  ]

  mounts {
    type   = "bind"
    source = "${WORKING_DIRECTORY}/volumes/db/realtime.sql"
    target = "/docker-entrypoint-initdb.d/migrations/99-realtime.sql"
  }
  #
  # Must be superuser to create event trigger
  mounts {
    type   = "bind"
    source = "${WORKING_DIRECTORY}/volumes/db/webhooks.sql"
    target = "/docker-entrypoint-initdb.d/init-scripts/98-webhooks.sql"
  }
  #
  # Must be superuser to alter reserved role
  mounts {
    type   = "bind"
    source = "${WORKING_DIRECTORY}/volumes/db/roles.sql"
    target = "/docker-entrypoint-initdb.d/init-scripts/99-roles.sql"
  }
  #
  # Initialize the database settings with JWT_SECRET and JWT_EXP
  mounts {
    type   = "bind"
    source = "${WORKING_DIRECTORY}/volumes/db/jwt.sql"
    target = "/docker-entrypoint-initdb.d/init-scripts/99-jwt.sql"
  }
  # PGDATA directory is persisted between restarts
  volumes {
    # type   = "bind"
    host_path = "${WORKING_DIRECTORY}/volumes/db/data"
    container_path = "/var/lib/postgresql/data"
  }
  #
  # Changes required for internal supabase data such as _analytics
  mounts {
    type   = "bind"
    source = "${WORKING_DIRECTORY}/volumes/db/_supabase.sql"
    target = "/docker-entrypoint-initdb.d/migrations/97-_supabase.sql"
  }
  #
  # Changes required for Analytics support
  mounts {
    type   = "bind"
    source = "${WORKING_DIRECTORY}/volumes/db/logs.sql"
    target = "/docker-entrypoint-initdb.d/migrations/99-logs.sql"
  }
  #
  # Changes required for Pooler support
  mounts {
    type   = "bind"
    source = "${WORKING_DIRECTORY}/volumes/db/pooler.sql"
    target = "/docker-entrypoint-initdb.d/migrations/99-pooler.sql"
  }
  #
  volumes {
    volume_name    = "db-config"
    container_path = "/etc/postgresql-custom"
  }


  depends_on = [docker_container.vector]

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "vector" {
  name    = "vector"
  image   = docker_image.vector.image_id
  restart = "unless-stopped"
  

  healthcheck {
    test = [
      "CMD",
      "wget",
      "--no-verbose",
      "--tries=1",
      "--spider",
      "http://vector:9001/health"
    ]
    interval = "5s"
    timeout  = "5s"
    retries  = 3
  }

  command = [
    "--config",
    "etc/vector/vector.yml"
  ]

  env = [
    "LOGFLARE_API_KEY=${LOGFLARE_API_KEY}"
  ]

  mounts {
    type      = "bind"
    target    = "/etc/vector/vector.yml"
    # container_path =  "/etc/vector/vector.yml"
    # host_path    = "${WORKING_DIRECTORY}/volumes/logs/vector.yml"
    source    = "${WORKING_DIRECTORY}/volumes/logs/vector.yml"
    read_only = true
  }

  mounts {
    type      = "bind"
    target    = "/var/run/docker.sock"
    source    = "${DOCKER_SOCKET_LOCATION}"
    read_only = true
  }

  networks_advanced {
    name = "supabase_network"
  }

}

resource "docker_container" "supavisor" {
  name    = "supavisor"
  image   = docker_image.supavisor.image_id
  restart = "unless-stopped"
  

  healthcheck {
    test = [
      "curl",
      "-sSfL",
      "--head",
      "-o",
      "/dev/null",
      "http://127.0.0.1:4000/api/health"
    ]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }

  command = ["/bin/sh", "-c", "/app/bin/server"]

  env = [
    "PORT=4000",
    "POSTGRES_PORT=${POSTGRES_PORT}",
    "POSTGRES_DB=${POSTGRES_DB}",
    "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}",
    "DATABASE_URL=ecto://postgres:${POSTGRES_PASSWORD}@db:${POSTGRES_PORT}/_supabase",
    "CLUSTER_POSTGRES=true",
    "SECRET_KEY_BASE=UpNVntn3cDxHJpq99YMc1T1AQgQpc8kfYTuRgBiYa15BLrx8etQoXz3gZv1/u2oq",
    "VAULT_ENC_KEY=your-encryption-key-32-chars-min",
    "API_JWT_SECRET=${JWT_SECRET}",
    "METRICS_JWT_SECRET=${JWT_SECRET}",
    "REGION=local",
    "ERL_AFLAGS=-proto_dist inet_tcp",
    "POOLER_TENANT_ID=${POOLER_TENANT_ID}",
    "POOLER_DEFAULT_POOL_SIZE=${POOLER_DEFAULT_POOL_SIZE}",
    "POOLER_MAX_CLIENT_CONN=${POOLER_MAX_CLIENT_CONN}",
    "POOLER_POOL_MODE=transaction",
  ]

  ports {
    internal = 5432
    external = "${POSTGRES_PORT}"
  }

  ports {
    internal = 6543
    external = "${POOLER_PROXY_PORT_TRANSACTION}"
  }

  mounts {
    type = "bind"
    target = "/etc/pooler/pooler.exs"
    source = "${WORKING_DIRECTORY}/volumes/pooler/pooler.exs"
    read_only = true
  }

  depends_on = [docker_container.db, docker_container.analytics]

  networks_advanced {
    name = "supabase_network"
  }
}


resource "docker_container" "weaviate" {
  name    = "weaviate"
  image   = docker_image.weaviate.image_id
  restart = "on-failure"
  
  command = [
    "--host",
    "0.0.0.0",
    "--port",
    "8080",
    "--scheme",
    "http",
  ]

  ports {
    internal = 8080
    external = 8090
  }

  ports {
    internal = 50051
    external = 50051
  } 

  # volumes {
  #   volume_name = "weaviate_data"
  #   container_path = "/var/lib/weaviate"
  # }


  env = [
    "QUERY_DEFAULTS_LIMIT=25",
    "AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED='true'",
    "PERSISTENCE_DATA_PATH='/var/lib/weaviate'",
    "ENABLE_MODULES=img2vec-neural",
    "DEFAULT_VECTORIZER_MODULE=img2vec-neural",
    "IMAGE_INFERENCE_API=http://img2vec:8080",
    "ENABLE_API_BASED_MODULES='true'",
    "CLUSTER_HOSTNAME='node1'"
  ]

  depends_on = [docker_container.img2vec]

  networks_advanced {
    name = "supabase_network"
  }

}


resource "docker_container" "img2vec" {
  name    = "img2vec"
  image   = docker_image.img2vec.image_id
  restart = "on-failure"

  env = [
    "ENABLE_CUDA=0"
  ]
  
  ports {
    internal = 8080
    external = 9090
  }

  networks_advanced {
    name = "supabase_network"
  }

}

resource "docker_container" "caddy" {
  name    = "caddy"
  image   = docker_image.caddy.image_id
  restart = "unless-stopped"
  
  env = [
    "DOMAIN=cat-egorizer.sanguinare.dev",
    "EMAIL=tumicooll@gmail.com",
    "LOG_FILE=/data/access.log"
  ]

  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }

  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }

  ports {
    internal = 443
    external = 443
    protocol = "udp"
  }

  mounts {
    type   = "bind"
    source = "${WORKING_DIRECTORY}/Caddyfile"
    target = "/etc/caddy/Caddyfile"
    read_only = true
  }
  
  
  volumes {
    host_path = "${WORKING_DIRECTORY}/caddy-config"
    container_path = "/config"
  }

  volumes {
    # type   = "bind"
    host_path = "${WORKING_DIRECTORY}/caddy-data"
    container_path = "/data"
  }

  networks_advanced {
    name = "supabase_network"
  }
}

resource "docker_container" "webui" {
  name    = "webui"
  image   = docker_image.webui.image_id
  restart = "on-failure"

  env = [
    "OPENAI_API_KEY=${OPENAI_API_KEY}"
  ]
  
  volumes {
    host_path = "${WORKING_DIRECTORY}/volumes/open-webui"
    container_path = "/app/backend/data"
  }

  networks_advanced {
    name = "supabase_network"
  }

}