defmodule Aoc03 do
  use Application

  @moduledoc """
  Documentation for `Aoc03`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc03.hello()
      :world

  """

  def start(_type, _args) do
    main()
    System.halt(0)
  end

  def main do
    data = Aoc03.Parse.parse_file("data.txt")

    p1_result =
      data
      |> Enum.map(fn vals -> Aoc03.Count.find_max_combo(vals, 2) end)
      |> Enum.sum()

    p2_result =
      data
      |> Enum.map(fn vals -> Aoc03.Count.find_max_combo(vals, 12) end)
      |> Enum.sum()

    IO.puts(p1_result)
    IO.puts(p2_result)
  end
end
