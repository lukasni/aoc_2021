defmodule AdventOfCode.Day05 do
  alias __MODULE__.Parser

  def part1(input) do
    input
    |> Parser.parse_input()
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} ->
      x1 == x2 or y1 == y2
    end)
    |> Enum.reduce(%{}, fn {{x1, y1}, {x2, y2}}, acc ->
      for x <- x1..x2, y <- y1..y2, reduce: acc do
        acc -> Map.update(acc, {x, y}, 1, &(&1 + 1))
      end
    end)
    |> Map.values()
    |> Enum.count(&(&1 >= 2))
  end

  def part2(input) do
    input
    |> Parser.parse_input()
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} = coords ->
      x1 == x2 or y1 == y2 or at_45_degrees?(coords)
    end)
    |> mark_lines()
    |> Map.values()
    |> Enum.count(&(&1 >= 2))
  end

  defp mark_lines(coords) do
    Enum.reduce(coords, %{}, fn {{x1, y1}, {x2, y2}}, acc ->
      steps = max(abs(x2 - x1), abs(y2 - y1))
      dx = div(x2 - x1, steps)
      dy = div(y2 - y1, steps)

      Stream.iterate({x1, y1}, fn {x, y} -> {x + dx, y + dy} end)
      |> Stream.take(steps + 1)
      |> Enum.to_list()
      |> Enum.reduce(acc, fn point, inner_acc -> Map.update(inner_acc, point, 1, &(&1 + 1)) end)
    end)
  end

  def at_45_degrees?({{x1, y1}, {x2, y2}}) do
    rise = y2 - y1
    run = x2 - x1

    slope = rise / run
    # IO.puts("(#{x1},#{y1}),(#{x2},#{y2}) -> #{slope}")
    abs(slope) == 1
  end

  defmodule Parser do
    def parse_input(input) do
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)
    end

    def parse_line(line) do
      line
      |> String.split(" -> ", trim: true)
      |> Enum.map(&parse_coords/1)
      |> List.to_tuple()
    end

    def parse_coords(coords) do
      coords
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end
  end
end
