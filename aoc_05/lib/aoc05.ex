defmodule Aoc05 do
  use Application

  @moduledoc """
  Documentation for `Aoc05`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc05.hello()
      :world

  """
  def start(_, _) do
    main()
    System.halt(0)
  end

  def main do
    {ranges, ingredients} = Aoc05.Parse.parse_file("data.txt")
    p1 = Aoc05.Check.get_fresh_ingredients(ingredients, ranges) |> length

    p2 =
      Enum.reduce(ranges, [], fn r, acc -> Aoc05.Ranges.insert_range(r, acc) end)
      |> Enum.reduce(0, fn {low, high}, acc -> acc + 1 + high - low end)

    IO.inspect(p1)
    IO.inspect(p2)
  end
end
