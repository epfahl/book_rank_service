defmodule BookRankService.Router do
  use Plug.Router
  alias BookRankService.Scraper

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Nothing to see here. Try calling /rank/:asin.")
  end

  get "/rank/:asin" do
    info = get_info_with_time(asin)
    send_resp(conn, 200, info)
  end

  match _ do
    send_resp(conn, 404, "What the hell are you doing?!.")
  end

  defp get_info_with_time(asin) do
    asin
    |> Scraper.scrape_info()
    |> Map.merge(%{"time" => get_utc_string()})
    |> Poison.encode!()
  end

  defp get_utc_string() do
    DateTime.utc_now()
    |> DateTime.to_string()
  end
end
