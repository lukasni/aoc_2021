defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> parse()
    |> find_local_minimums()
    |> Enum.reduce(0, fn {_coords, height}, acc -> acc + height + 1 end)
  end

  def part2(input) do
    input
    |> parse()
    |> find_basins()
    |> Enum.map(&basin_size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {data, row}, heightmap ->
      data
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(heightmap, fn {height, col}, heightmap ->
        Map.put(heightmap, {row, col}, String.to_integer(height))
      end)
    end)
  end

  defp adjacent_coordinates({x, y}) do
    [{x, y + 1}, {x, y - 1}, {x - 1, y}, {x + 1, y}]
  end

  defp get_adjacent({x, y}, heightmap) do
    {x, y}
    |> adjacent_coordinates()
    |> Enum.map(&{&1, Map.get(heightmap, &1, nil)})
  end

  defp find_local_minimums(heightmap) do
    heightmap
    |> Enum.filter(fn {coords, _height} = point ->
      is_local_minimum(point, get_adjacent(coords, heightmap))
    end)
  end

  defp is_local_minimum({_coordinates, height}, adjacent) do
    adjacent_heights = adjacent |> Enum.map(&elem(&1, 1))

    height < Enum.min(adjacent_heights)
  end

  defp find_basins(heightmap) do
    heightmap
    |> find_local_minimums()
    |> Enum.map(fn lowpoint ->
      [lowpoint]
      |> fill(heightmap)
      |> Enum.uniq()
    end)
  end

  defp fill(lowpoints, heightmap, basin \\ [])
  defp fill([], _, basin), do: basin

  defp fill([{coordinate, height} = lowpoint | lowpoints], heightmap, basin) do
    expanded =
      coordinate
      |> get_adjacent(heightmap)
      |> Enum.reject(fn {_coords, h} -> h <= height || h == 9 || h == nil end)

    fill(lowpoints ++ expanded, heightmap, basin ++ [lowpoint | expanded])
  end

  defp basin_size(basin) do
    Enum.count(basin)
  end
end
