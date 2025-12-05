defmodule Aoc05.Parse do
  import NimbleParsec

  def parse_file(file_path) do
    file_contents =
      File.stream!(file_path)
      |> Enum.map(&String.trim/1)

    ranges =
      file_contents
      |> parse_ranges()
      |> Enum.map(fn {:ok, [low, high], _, _, _, _} -> {low, high} end)

    ingredients =
      Enum.drop(file_contents, length(ranges) + 1)
      |> parse_ingredients
      |> Enum.map(fn {:ok, [val], _, _, _, _} -> val end)

    {ranges, ingredients}
  end

  defp parse_ranges(["" | _]), do: []
  defp parse_ranges([head | tail]), do: [parse_range(head) | parse_ranges(tail)]
  defp parse_ingredients([]), do: []
  defp parse_ingredients([head | tail]), do: [parse_ingredient(head) | parse_ingredients(tail)]

  defparsec(:parse_range, integer(min: 1) |> ignore(string("-")) |> integer(min: 1))
  defparsec(:parse_ingredient, integer(min: 1))
end

defmodule Aoc05.Check do
  def get_fresh_ingredients(ingredients, ranges),
    do: Enum.filter(ingredients, fn ing -> is_in_any_range(ing, ranges) end)

  defp is_in_any_range(_, []), do: false

  defp is_in_any_range(ingredient, [head | tail]),
    do: is_in_range(ingredient, head) or is_in_any_range(ingredient, tail)

  defp is_in_range(ingredient, {low, high}), do: ingredient >= low and ingredient <= high
end

defmodule Aoc05.Ranges do
  defp combine_ranges({l1, h1}, {l2, h2}) do
    if l1 > h2 or h1 < l2 do
      [{l1, h1}, {l2, h2}]
    else
      [{min(l1, l2), max(h1, h2)}]
    end
  end

  def insert_range(range, []), do: [range]

  def insert_range(range, [head | tail]) do
    case combine_ranges(range, head) do
      [_, _] -> [head | insert_range(range, tail)]
      [new_range] -> insert_range(new_range, tail)
    end
  end
end
