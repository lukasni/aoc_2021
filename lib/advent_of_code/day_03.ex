defmodule AdventOfCode.Day03 do
  def part1(input) do
    gamma_binary =
      input
      |> String.trim()
      |> String.split()
      |> Enum.map(&String.graphemes/1)
      |> List.zip
      |> Enum.map(&gamma/1)

    epsilon_binary = gamma_to_epsilon(gamma_binary)

    Integer.undigits(gamma_binary, 2) * Integer.undigits(epsilon_binary, 2)
  end

  defp gamma(input) do
    threshold = tuple_size(input) / 2

    sum =
      input
      |> Tuple.to_list()
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    case sum > threshold do
      true -> 1
      false -> 0
    end
  end

  defp gamma_to_epsilon(gamma) do
    Enum.map(gamma, fn 1 -> 0; 0 -> 1 end)
  end

  def part2(input) do
    parsed =
      input
      |> String.trim()
      |> String.split()
      |> Enum.map(&String.graphemes/1)

    o2 = o2(parsed)
    co2 = co2(parsed)

    o2 * co2
  end

  defp o2(items, index \\ 0)
  defp o2([result], _) do
    result
    |> Enum.map(&String.to_integer/1)
    |> Integer.undigits(2)
  end

  defp o2(items, index) do
    most_frequent =
      items
      |> transpose()
      |> Enum.at(index)
      |> Enum.frequencies
      |> Map.to_list()
      |> Enum.sort_by(&elem(&1,1), & &1 > &2)
      |> List.first()
      |> elem(0)

    items
    |> Enum.filter(fn i -> Enum.at(i, index) == most_frequent end)
    |> o2(index + 1)
  end

  defp co2(items, index \\ 0)
  defp co2([result], _) do
    result
    |> Enum.map(&String.to_integer/1)
    |> Integer.undigits(2)
  end

  defp co2(items, index) do
    most_frequent =
      items
      |> transpose()
      |> Enum.at(index)
      |> Enum.frequencies
      |> Map.to_list()
      |> Enum.sort_by(&elem(&1,1), & &1 <= &2)
      |> List.first()
      |> elem(0)

    items
    |> Enum.filter(fn i -> Enum.at(i, index) == most_frequent end)
    |> co2(index + 1)
  end

  defp transpose(list) do
    list
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
