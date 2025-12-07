defmodule Aoc07 do
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
    {splits, timelines} = Aoc07.Parse.parse_file("data.txt") |> Aoc07.Solve.count({0, 70})
    IO.inspect(splits)
    IO.inspect(timelines)
  end
end
