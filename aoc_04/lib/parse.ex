defmodule Aoc04.Parse do
  import NimbleParsec
  import Nx

  def parse_file(fname) do
    File.stream!(fname)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&parse_line/1)
    |> Nx.tensor()
  end

  defp parse_line(line), do: Enum.map(String.to_charlist(line), &full/1)

  defp full(?.), do: false
  defp full(?@), do: true

  defp full(c) do
    raise("Bad value detected #{c}")
  end
end

defmodule Aoc04.Count do
  def get_free_indices(tensor, max) do
    {rows, columns} = tensor.shape

    res =
      for r <- 0..(rows - 1),
          c <- 0..(columns - 1),
          do: [r, c]

    res
    |> Enum.filter(fn [row, column] ->
      Nx.to_number(tensor[[row, column]]) == 1 and count_neighbors(tensor, row, column) < max
    end)
  end

  def count_all_removals(tensor, max) do
    _count_all_removals(tensor, max)
  end

  defp _count_all_removals(tensor, max) do
    indices_to_remove = get_free_indices(tensor, max)

    case length(indices_to_remove) do
      0 ->
        0

      len ->
        len +
          _count_all_removals(
            Nx.indexed_put(tensor, indices_to_remove |> Nx.tensor(), Nx.broadcast(0, {len})),
            max
          )
    end
  end

  def count_neighbors(tensor, row, column) do
    idxs = neighbor_indices(row, column, tensor.shape)
    neighbors = Nx.gather(tensor, Nx.tensor(idxs))
    neighbors |> Nx.sum() |> Nx.to_number()
  end

  def neighbor_indices(row, column, {nrows, ncols}) do
    case Agent.get(:cache, &Map.get(&1, {row, column})) do
      {:ok, val} ->
        val

      _ ->
        idxs =
          for r <- -1..1,
              c <- -1..1,
              do: [row + r, column + c]

        idxs_ =
          idxs
          |> Enum.filter(fn [r, c] -> r != row or c != column end)
          |> Enum.filter(fn [r, c] -> r >= 0 and c >= 0 and r < nrows and c < ncols end)

        Agent.update(:cache, &Map.put(&1, {row, column}, idxs_))
        idxs_
    end
  end
end
