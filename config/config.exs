import Config

config :nx, default_defn_options: [compiler: EXLA, client: :host]

config :advent_of_code,
  session_id: System.get_env("SESSION_ID")
