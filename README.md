# BookRankService

## ToDo

* Accept a JSON POST of a list of ASINs.
* Async processes each ASIN (Task?).
    * See [this](http://www.simon-neutert.de/2017/async-http-requests-elixir/).
* Get other metadata for book per ASIN:
    * title
    * author
    * cover image url
* Compile rank regex?
* Figure out why return so slow:
    * slow HTTP request for HTML?
    * large HTML file?
    * slow parsing/scraping?
* Localize time to eastern.
