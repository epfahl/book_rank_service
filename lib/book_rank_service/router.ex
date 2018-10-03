defmodule BookRankService.Router do
  use Plug.Router
  alias BookRankService.Scraper

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Nothing to see here. Try calling /rank/:asin.")
  end

  post "/test" do
    IO.inspect(conn.body_params)
    result = pmap(conn.body_params["_json"], &String.capitalize/1)
    send_resp(conn, 200, Poison.encode!(result))
  end

  post "/ranks" do
    IO.inspect(conn.body_params)
    result = conn.body_params["_json"] |> pmap(&get_asin_info/1)
    send_resp(conn, 200, result)
    # send_resp(conn, 200, Poison.encode!(result))
  end

  get "/rank/:asin" do
    info = get_asin_info(asin)
    send_resp(conn, 200, info)
  end

  match _ do
    send_resp(conn, 404, "What the hell are you doing?!.")
  end

  defp get_asin_info(asin) do
    asin
    |> Scraper.scrape_info()
    |> Poison.encode!()
  end

  defp capitalize(strings) do
    pmap(strings, &String.capitalize/1)
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await/1)
  end
end
