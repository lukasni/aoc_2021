defmodule AdventOfCode.Day07 do
  def part1(input) do
    numbers =
      input
      |> parse()

    {min, max} = Enum.min_max(numbers)

    min..max
    |> Enum.map(fn destination ->
      numbers
      |> Enum.map(&calculate_fuel_1(&1, destination))
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def part2(input) do
    numbers =
      input
      |> parse()

    {min, max} = Enum.min_max(numbers)

    min..max
    |> Enum.map(fn destination ->
      numbers
      |> Enum.map(&calculate_fuel_2(&1, destination))
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp calculate_fuel_1(origin, destination) do
    abs(destination - origin)
  end

  defp calculate_fuel_2(origin, destination) do
    1..abs(destination - origin) |> Enum.sum()
  end
end
