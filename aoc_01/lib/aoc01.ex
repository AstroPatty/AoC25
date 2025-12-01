defmodule Aoc01 do
  use Application

  @moduledoc """
  Documentation for `Aoc01`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc01.hello()
      :world

  """
  def start(_type, _args) do
    main()
    System.halt(0)
  end

  def main do
    parsed = Aoc01.Parse.parse_file("data.txt")
    stops = Aoc01.Run.do_all_moves(parsed, 50)
    p1 = Enum.reduce(stops, 0, fn val, acc -> if val == 0, do: acc + 1, else: acc end)
    crosses = Aoc01.Run.do_moves_with_counts(parsed, 50)
    p2 = Enum.reduce(crosses, 0, fn {c, _}, acc -> acc + c end)

    IO.inspect(p1)
    IO.inspect(p2)
    IO.puts("done")
  end
end
