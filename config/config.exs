import Config

config :nx, default_defn_options: [compiler: EXLA, client: :rocm]

# on year 2021, day 06 we are using Nx at compile time, which is not compatible with EXLA
# config :nx, default_backend: {EXLA.Backend, client: :rocm}

config :advent_of_code,
  session_id: System.get_env("SESSION_ID")
