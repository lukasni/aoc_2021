defmodule AdventOfCode.Day11 do
  alias __MODULE__.Recursion
  def part1(input) do
    grid =
      input
      |> parse()

    1..100
    |> Enum.map_reduce(grid, fn _, grid ->
      {grid, flashed} = Recursion.step(grid)
      {flashed, grid}
    end)
    |> elem(0)
    |> Enum.sum()
  end

  def part2(input) do
    grid =
      input
      |> parse()

    Stream.iterate(1, & &1 + 1)
    |> Enum.reduce_while(grid, fn i, grid ->
      case Recursion.step(grid) do
        {grid, flashes} when map_size(grid) == flashes -> {:halt, i}
        {grid, _flashes} -> {:cont, grid}
      end
    end)
  end

  defp parse(input) do
    lines = String.split(input, "\n", trim: true)

    for {line, row} <- Enum.with_index(lines),
        {energy, col} <- Enum.with_index(String.graphemes(line)),
        into: %{},
        do: {{row, col}, String.to_integer(energy)}
  end

  defmodule Recursion do
    def step(grid) do
      flash(Map.keys(grid), grid, MapSet.new())
    end

    defp flash([{row, col} = key | keys], grid, flashed) do
      value = grid[key]

      cond do
        is_nil(value) or key in flashed ->
          flash(keys, grid, flashed)

        grid[key] >= 9 ->
          keys = [
            {row - 1, col - 1},
            {row - 1, col},
            {row - 1, col + 1},
            {row, col - 1},
            {row, col + 1},
            {row + 1, col - 1},
            {row + 1, col},
            {row + 1, col + 1}
            | keys
          ]

          flash(keys, Map.put(grid, key, 0), MapSet.put(flashed, key))

        true ->
          flash(keys, Map.put(grid, key, value + 1), flashed)
      end
    end

    defp flash([], grid, flashed) do
      {grid, MapSet.size(flashed)}
    end
  end
end
