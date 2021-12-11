defmodule AdventOfCode.Day10 do
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&score_line/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.reject(&(score_line(&1) > 0))
    |> Enum.map(&autocomplete/1)
    |> median()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp score_line(line) do
    line
    |> Enum.reduce_while({0, []}, fn
      character, {score, []} ->
        {:cont, {score, [character]}}

      character, {score, [last | rest] = stack} ->
        cond do
          character in openers() ->
            {:cont, {score, [character | stack]}}

          closes?(character, last) ->
            {:cont, {score, rest}}

          true ->
            {:halt, {score_for(character), stack}}
        end
    end)
    |> elem(0)
  end

  defp score_for(")"), do: 3
  defp score_for("]"), do: 57
  defp score_for("}"), do: 1197
  defp score_for(">"), do: 25137

  defp closes?(")", "("), do: true
  defp closes?("]", "["), do: true
  defp closes?("}", "{"), do: true
  defp closes?(">", "<"), do: true
  defp closes?(_, _), do: false

  def closes("("), do: ")"
  def closes("["), do: "]"
  def closes("{"), do: "}"
  def closes("<"), do: ">"

  defp openers() do
    ["(", "[", "{", "<"]
  end

  defp autocomplete(line) do
    line
    |> Enum.reduce([], fn
      char, [] ->
        [char]

      character, [last | rest] = stack ->
        cond do
          closes?(character, last) ->
            rest

          true ->
            [character | stack]
        end
    end)
    |> Enum.reduce(0, fn character, score ->
      score = score * 5

      case character do
        "(" ->
          score + 1

        "[" ->
          score + 2

        "{" ->
          score + 3

        "<" ->
          score + 4
      end
    end)
  end

  defp median(list) do
    list
    |> Enum.sort()
    |> Enum.at(div(length(list), 2))
  end
end
