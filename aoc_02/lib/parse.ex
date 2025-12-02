defmodule Aoc02.Parse do
  import NimbleParsec

  product_range =
    integer(min: 1) |> ignore(string("-")) |> integer(min: 1) |> ignore(optional(string(",")))

  defparsec(:parse, repeat(product_range))

  def parse_file(file_path) do
    {:ok, results, _, _, _, _} = Aoc02.Parse.parse(File.read!(file_path))
    Enum.chunk_every(results, 2)
  end
end
