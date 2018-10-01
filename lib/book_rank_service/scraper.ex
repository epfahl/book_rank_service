defmodule BookRankService.Scraper do
  @url_base ~S("https://www.amazon.com/dp/#{asin}")
  @rank_id "SalesRank"
  @rank_regex ~r/#(?<rank>[0-9]{1,3}(,[0-9]{3})*) (?<free>Paid|Free)/

  @doc """
  Given a book ASIN, return a map that includes the rank and a boolean
  that indicates if the book is free or not.

  %{"asin" => ASIN, "rank" => 123, "free" => false}
  """
  def scrape_info(asin) do
    asin
    |> get_html_by_asin()
    |> get_info_from_html()
    |> Map.put("asin", asin)
  end

  defp get_html_by_asin(asin) do
    asin
    |> get_url_by_asin()
    |> get_html()
  end

  defp get_info_from_html(html) do
    find_by_id(html, @rank_id)
    |> Floki.text(deep: false)
    |> String.trim()
    |> (&Regex.named_captures(@rank_regex, &1)).()
    |> Map.update!("rank", &string_to_integer(&1))
    |> Map.update!("free", &(&1 == "Free"))
  end

  defp find_by_id(html, id) do
    Floki.find(html, "##{id}")
  end

  defp string_to_integer(s) do
    s
    |> String.replace(",", "")
    |> String.to_integer()
  end

  defp get_html(url) do
    {:ok, %{body: html}} = HTTPoison.get(url)
    html
  end

  defp get_url_by_asin(asin) do
    asin
    |> (&Code.eval_string(@url_base, asin: &1)).()
    |> elem(0)
  end
end
