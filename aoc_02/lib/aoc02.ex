defmodule Aoc02 do
  use Application

  @moduledoc """
  Documentation for `Aoc02`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc02.hello()
      :world

  """
  def start(_type, _args) do
    main()
    System.halt(0)
  end

  def main do
    data = Aoc02.Parse.parse_file("data.txt")

    result_p1 =
      Aoc02.Find.check_ranges(data, &Aoc02.Find.is_repeated_pair/1)
      |> Enum.sum()

    result_p2 = Aoc02.Find.check_ranges(data, &Aoc02.Find.is_repeated_any/1) |> Enum.sum()

    IO.inspect(result_p1)
    IO.inspect(result_p2)
  end
end
