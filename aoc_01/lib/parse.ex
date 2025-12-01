defmodule Aoc01.Parse do
  import NimbleParsec
  direction = choice([string("L"), string("R")])
  distance = integer(min: 1)
  defparsec(:parse, direction |> concat(distance))

  def parse_file(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Enum.map(fn s -> Aoc01.Parse.parse(s) end)
    |> Enum.map(fn s -> Aoc01.Parse.to_output(s) end)
  end

  def to_output({:ok, move, _, _, _, _}) do
    [dir, dist] = move
    {String.to_atom(dir), dist}
  end

  def parse_lines([]), do: []
  def parse_lines([head | tail]), do: [parse(head) | parse_lines(tail)]
end
