import Config

config :nx, :default_defn_options, compiler: EXLA, client: :cuda

if File.exists?("config/secret.exs") do
  import_config("secret.exs")
end
