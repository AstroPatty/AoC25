defmodule Aoc03.Count do
  def find_max_combo(vals, n) do
    find_combo(vals, n) |> Enum.reduce(fn v, acc -> acc * 10 + v end)
  end

  defp find_combo(_, 0), do: []

  defp find_combo(vals, n) when is_integer(n) do
    left = Enum.drop(vals, -n + 1)

    {max_value, max_index} = Enum.with_index(left) |> Enum.max_by(fn {v, _} -> v end)
    [max_value | find_combo(Enum.drop(vals, max_index + 1), n - 1)]
  end
end

defmodule Aoc03.Parse do
  import NimbleParsec

  def parse_file(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Enum.map(fn s -> Aoc03.Parse.digits(s) end)
    |> Enum.map(fn {:ok, vals, _, _, _, _} -> vals end)
  end

  defparsec(:digits, repeat(integer(1)))
end
