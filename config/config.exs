import Config

config :advent_of_code, AdventOfCode.Input,
  allow_network?: true,
  session_cookie: System.get_env("SESSION_KEY")

# If you don't like environment variables, put your cookie in
# a `config/secrets.exs` file like this:
#
# use Mix.Config
# config :advent_of_code, AdventOfCode.Input,
#   session_cookie: "..."

try do
  import_config "secrets.exs"
rescue
  _ -> :ok
end
