import Config

# To use cuda/rocm/tpu, set the client too
config :nx, :default_defn_options, compiler: EXLA, client: :cuda
