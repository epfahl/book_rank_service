defmodule BookRankService.Application do
  use Application

  def start(_type, _args) do
    port = Application.get_env(:book_rank_service, :http_port)

    children = [
      {
        Plug.Adapters.Cowboy2,
        scheme: :http, plug: BookRankService.Router, options: [port: port]
      }
    ]

    opts = [strategy: :one_for_one, name: BookRankService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
