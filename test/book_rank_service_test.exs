defmodule BookRankServiceTest do
  use ExUnit.Case
  doctest BookRankService

  test "greets the world" do
    assert BookRankService.hello() == :world
  end
end
