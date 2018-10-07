use Mix.Config

# Note that the PORT is a string when read from the environment.  The String
# is converted to an integer in the application module.

port = System.get_env("PORT") || "8765"
config :book_rank_service, http_port: String.to_integer(port)
