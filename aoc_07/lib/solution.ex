defmodule Aoc07.Parse do
  def parse_file(file) do
    File.stream!(file)
    # Trim whitespace and newline characters from each line
    |> Stream.map(&String.trim/1)
    # Convert the stream to a list
    |> Stream.with_index()
    |> Stream.map(&find_splits/1)
    |> Stream.concat()
  end

  def find_splits({line, linenum}) do
    split_indices =
      String.to_charlist(line)
      |> Stream.with_index()
      |> Stream.filter(fn {char, _} -> char == ?^ end)
      |> Stream.map(fn {_, idx} -> idx end)

    indices = for col <- split_indices, do: {linenum, col}
    indices
  end
end

defmodule Aoc07.Solve do
  import Cachex

  def count(split_points, start) do
    Cachex.start_link(:path_cache)
    shoot_ray(split_points, start)
  end

  defp shoot_ray(split_points, {start_y, start_x}) do
    split =
      Stream.with_index(split_points)
      |> Enum.find(fn {{y, x}, _} -> y > start_y and x == start_x end)

    if split == nil do
      # {splits, timelines}
      {0, 1}
    else
      shoot_child_rays(split_points, split)
    end
  end

  defp shoot_child_rays(split_points, {{split_y, split_x}, index}) do
    {:ok, result} = Cachex.get(:path_cache, {split_y, split_x})

    if result == nil do
      new_input = Enum.drop(split_points, index + 1)
      {rsplit, rtime} = shoot_ray(new_input, {split_y + 1, split_x + 1})

      {lsplit, ltime} = shoot_ray(new_input, {split_y + 1, split_x - 1})

      res = {1 + rsplit + lsplit, rtime + ltime}

      Cachex.put(:path_cache, {split_y, split_x}, res)
      res
    else
      {_, timelines} = result
      {0, timelines}
    end
  end
end
