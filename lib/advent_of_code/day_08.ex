defmodule AdventOfCode.Day08 do
  alias __MODULE__.Decoder

  def part1(input) do
    input
    |> parse()
    |> Enum.map(fn {_, output} ->
      Enum.count(output, &(MapSet.size(&1) in [2, 3, 4, 7]))
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(fn {signal, [thousands, hundreds, tens, ones]} ->
      rules = Decoder.build_rules(signal)

      values =
        signal
        |> Enum.map(&Decoder.decode(&1, rules))

      {thousands, _} = Enum.find(values, 0, &MapSet.equal?(elem(&1, 1), thousands))
      {hundreds, _} = Enum.find(values, 0, &MapSet.equal?(elem(&1, 1), hundreds))
      {tens, _} = Enum.find(values, 0, &MapSet.equal?(elem(&1, 1), tens))
      {ones, _} = Enum.find(values, 0, &MapSet.equal?(elem(&1, 1), ones))

      1000 * thousands + 100 * hundreds + 10 * tens + ones
    end)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [signal, output] = String.split(line, " | ")

    signal =
      signal |> String.split(" ") |> Enum.map(&String.graphemes/1) |> Enum.map(&MapSet.new/1)

    output =
      output |> String.split(" ") |> Enum.map(&String.graphemes/1) |> Enum.map(&MapSet.new/1)

    {signal, output}
  end

  defmodule Decoder do
    def build_rules(signal) do
      rules = %{
        1 => Enum.find(signal, &(MapSet.size(&1) == 2)),
        4 => Enum.find(signal, &(MapSet.size(&1) == 4)),
        7 => Enum.find(signal, &(MapSet.size(&1) == 3)),
        8 => Enum.find(signal, &(MapSet.size(&1) == 7))
      }

      Map.put(rules, :diff, MapSet.difference(rules[4], rules[1]))
    end

    def decode(number, rules) do
      case MapSet.size(number) do
        2 ->
          {1, number}

        3 ->
          {7, number}

        4 ->
          {4, number}

        5 ->
          decode_five(number, rules)

        6 ->
          decode_six(number, rules)

        7 ->
          {8, number}
      end
    end

    defp decode_five(number, rules) do
      cond do
        MapSet.subset?(rules[1], number) ->
          {3, number}

        MapSet.subset?(rules[:diff], number) ->
          {5, number}

        true ->
          {2, number}
      end
    end

    defp decode_six(number, rules) do
      cond do
        MapSet.subset?(rules[4], number) ->
          {9, number}

        MapSet.subset?(rules[:diff], number) ->
          {6, number}

        true ->
          {0, number}
      end
    end
  end
end
