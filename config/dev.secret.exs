use Mix.Config

  config :ipr_api, IprApiWeb.Endpoint,
    # http: [port: System.get_env("HTTP_PORT")],
    # url: [host: System.get_env("URL_HOST"), port: System.get_env("URL_PORT")],
    secret_key_base: System.get_env("SECRET_KEY")

  config :ipr_api, IprApi.Repo,
    url: System.get_env("DB_URL"),
    pool_size: 15

  # config :cors_plug,
  #   origin: [System.get_env("ADMIN_URL"), System.get_env("APPLICANT_URL")],
  #   expose: ["token"]

  config :ipr_api, IprApi.Mailer,
    adapter: Bamboo.SMTPAdapter,
    server: "smtp.office365.com",
    port: 587,
    username: System.get_env("SMTP_USER"),
    password: System.get_env("SMTP_PASS"),
    # can be `:always` or `:never`
    tls: :if_available,
    # can be `true`
    ssl: false,
    retries: 1,
    auth: :if_available

  # config :ipr_api, IprApi.Mailer,
    # adapter: Bamboo.SMTPAdapter,
    # server: "smtp.gmail.com",
    # port: 587,
    # username: "demo@smarttechtank.com",
    # password: "workhardworksmart",
    # can be `:always` or `:never`
    # tls: :if_available,
    # can be `true`
    # ssl: false,
    # retries: 1

  config :sentry,
    dsn: "https://c6fc170316d0480cb9bf13ea9d83593c@sentry.io/1766050",
    environment_name: :prod,
    enable_source_code_context: true,
    root_source_code_path: File.cwd!,
    tags: %{
      env: "production"
    },
    included_environments: [:prod]