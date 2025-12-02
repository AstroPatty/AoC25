defmodule Aoc02.Find do
  def check_ranges(lst, checkfn) do
    lst
    |> Task.async_stream(fn item -> check_range(item, checkfn) end,
      max_concurrency: System.schedulers_online(),
      timeout: :infinity,
      ordered: false
    )
    |> Enum.reduce([], fn {:ok, result}, acc -> result ++ acc end)
  end

  defp check_range([low, high], checkfn),
    do: Enum.filter(low..high, fn val -> check(val, checkfn) end)

  defp check(num, checkfn) when is_integer(num), do: checkfn.(to_string(num))

  def is_repeated_any(numstr) do
    if String.length(numstr) == 1 do
      false
    else
      Enum.filter(1..div(String.length(numstr), 2), fn val ->
        Integer.mod(String.length(numstr), val) == 0
      end)
      |> Enum.reduce(false, fn val, acc -> acc or is_repeated_n(numstr, val) end)
    end
  end

  def is_repeated_pair(numstr) do
    if Integer.mod(String.length(numstr), 2) == 1 do
      false
    else
      is_repeated_n(numstr, div(String.length(numstr), 2))
    end
  end

  def is_repeated_n(numstr, n) do
    Enum.chunk_every(String.to_charlist(numstr), n)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(true, fn [l, r], acc -> acc and l == r end)
  end
end
