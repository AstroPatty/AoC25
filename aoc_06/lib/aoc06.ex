defmodule Aoc06 do
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
    Aoc06.Solve.solve_p1("data.txt") |> Enum.sum() |> IO.inspect()
    Aoc06.Solve.solve_p2("data.txt") |> Enum.sum() |> IO.inspect()
  end
end
