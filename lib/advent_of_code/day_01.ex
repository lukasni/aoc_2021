defmodule AdventOfCode.Day01 do
  @moduledoc """
  The first order of business is to figure out how quickly the depth
  increases, just so you know what you're dealing with - you never know if
  the keys will get carried into deeper water by an ocean current or a fish
  or something.

  To do this, count the number of times a depth measurement increases from
  the previous measurement. (There is no measurement before the first
  measurement.) In the example above, the changes are as follows:

  199 (N/A - no previous measurement)
  200 (increased)
  208 (increased)
  210 (increased)
  200 (decreased)
  207 (increased)
  240 (increased)
  269 (increased)
  260 (decreased)
  263 (increased)
  In this example, there are 7 measurements that are larger than the previous measurement.

  How many measurements are larger than the previous measurement?
  """

  @doc """
  Count the number of times the depth increases
  """
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [prev, curr] -> curr > prev end)
  end

  @doc """
  Count the number of times a three-number sliding window increases
  """
  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [prev, curr] -> curr > prev end)
  end
end
