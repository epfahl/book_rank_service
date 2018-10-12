defmodule BookRankService.Router do
  use Plug.Router
  alias BookRankService.Scraper

  plug(:match)

  plug(CORSPlug)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Nothing to see here. Try calling /rank/:asin.")
  end

  post "/rank" do
    result =
      conn.body_params["_json"]
      |> get_asin_info
      |> Poison.encode!()
      |> IO.inspect()

    send_resp(conn, 200, result)
  end

  post "/ranks" do
    result =
      conn.body_params["_json"]
      |> IO.inspect()
      |> pmap(&get_asin_info/1)
      |> Poison.encode!()

    send_resp(conn, 200, result)
  end

  match _ do
    send_resp(conn, 404, "What the hell are you doing?!.")
  end

  defp get_asin_info(asin) do
    asin
    |> Scraper.scrape_info()
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await/1)
  end
end
