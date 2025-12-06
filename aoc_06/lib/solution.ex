defmodule Aoc06.Parse do
  def parse_file(file) do
    File.stream!(file)
    # Trim whitespace and newline characters from each line
    |> Enum.map(&String.trim/1)
    # Convert the stream to a list
    |> Enum.to_list()
    |> parse_all_lines
  end

  defp parse_all_lines(lines) do
    {num_lines, [op_line]} = Enum.split(lines, -1)
    {Enum.map(num_lines, &parse_int_line/1), parse_op_line(op_line)}
  end

  def parse_int_line(line), do: String.split(line) |> Enum.map(&String.to_integer/1)
  def parse_int_with_empties(line), do: String.split(line) |> Enum.map(&String.to_integer/1)
  def is_integer?(char), do: char >= ?0 and char <= ?9

  def find_int_ranges([], _), do: []

  def find_int_ranges(line, counter \\ 0) do
    start = Enum.find_index(line, &is_integer?/1)
    len = Enum.drop(line, start) |> Enum.take_while(fn char -> is_integer?(char) end) |> length

    [
      {start + counter, start + counter + len - 1}
      | find_int_ranges(Enum.drop(line, start + len), counter + start + len)
    ]
  end

  def parse_op_line(line) when is_binary(line), do: String.split(line) |> parse_op_line
  def parse_op_line([]), do: []
  def parse_op_line(["+" | tail]), do: [(&Kernel.+/2) | parse_op_line(tail)]
  def parse_op_line(["*" | tail]), do: [(&Kernel.*/2) | parse_op_line(tail)]
end

defmodule Aoc06.Solve do
  def solve_p1(file) do
    {nums, ops} = Aoc06.Parse.parse_file(file)
    solve_problems(transpose(nums), ops)
  end

  def solve_p2(file) do
    charlists =
      File.stream!(file)
      |> Enum.map(&String.trim_trailing/1)
      |> Enum.map(&String.to_charlist/1)

    {numlists, ops} = Enum.split(charlists, -1)
    ranges = get_int_ranges(numlists)

    Enum.map(numlists, fn nl -> get_ints(nl, ranges) end)
    |> transpose
    |> Enum.map(&transpose/1)
    |> Enum.map(fn cls ->
      Enum.map(cls, fn cl ->
        Enum.filter(cl, &Aoc06.Parse.is_integer?/1) |> to_string |> String.to_integer()
      end)
    end)
    |> solve_problems(Aoc06.Parse.parse_op_line(to_string(ops)))
  end

  def get_ints(numlist, ranges) do
    {_, max} = List.last(ranges)

    numlist_ =
      to_string(numlist)
      |> String.pad_trailing(max + 1)
      |> String.to_charlist()

    Enum.map(ranges, fn r -> get_int(numlist_, r) end)
    |> Enum.map(fn cl ->
      Enum.map(cl, fn char -> if Aoc06.Parse.is_integer?(char), do: char, else: ?e end)
    end)
  end

  def get_int(numlist, {low, high}), do: Enum.drop(numlist, low) |> Enum.take(high - low + 1)

  def get_int_ranges(numlists) do
    Enum.map(numlists, &Aoc06.Parse.find_int_ranges/1)
    |> transpose
    |> Enum.map(fn list ->
      Enum.reduce(list, fn {low, high}, {clow, chigh} -> {min(low, clow), max(high, chigh)} end)
    end)
  end

  def solve_problems(numlists, ops),
    do: Enum.map(Enum.zip(numlists, ops), fn {nl, op} -> solve_problem(nl, op) end)

  def solve_problem(numbers, op), do: Enum.reduce(numbers, fn v, acc -> op.(v, acc) end)

  def transpose(lists) do
    if length(List.first(lists)) == 0 do
      []
    else
      vals = Enum.map(lists, &List.first/1)
      [vals | transpose(Enum.map(lists, fn l -> Enum.drop(l, 1) end))]
    end
  end
end
