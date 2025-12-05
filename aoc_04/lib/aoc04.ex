defmodule Aoc04 do
  use Application
  import Nx

  @moduledoc """
  Documentation for `Aoc04`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc04.hello()
      :world

  """
  def start(_, _) do
    main()
    System.halt(0)
  end

  def main do
    {:ok, _} = Agent.start_link(fn -> %{} end, name: :cache)
    result = Aoc04.Parse.parse_file("data.txt")
    IO.inspect(result)

    p1 = Aoc04.Count.get_free_indices(result, 4) |> length
    p2 = Aoc04.Count.count_all_removals(result, 4)

    IO.inspect(p1)
    IO.inspect(p2)
    :ok
  end
end
