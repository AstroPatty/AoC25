defmodule Aoc01.Run do
  def do_move(move, cur), do: Integer.mod(cur + get_change(move), 100)
  def get_change({:L, dist}), do: -dist
  def get_change({:R, dist}), do: dist

  def do_all_moves(moves, start) do
    Enum.scan([start | moves], fn elem, acc -> do_move(elem, acc) end)
  end

  def do_moves_with_counts(moves, start) do
    Enum.scan([{0, start} | moves], fn move, {_, start} ->
      {count_crosses(move, start), do_move(move, start)}
    end)
  end

  def count_crosses(move, start) do
    dm = get_change(move)
    full_turns = div(dm, 100)
    rem = dm - 100 * full_turns
    if start != 0 and move_crosses(rem, start), do: abs(full_turns) + 1, else: abs(full_turns)
  end

  def move_crosses(dm, start), do: dm + start >= 100 or dm + start <= 0
end
