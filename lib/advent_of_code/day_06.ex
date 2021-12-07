defmodule AdventOfCode.Day06 do
  alias __MODULE__.Model

  def part1(input, days \\ 80) do
    input
    |> parse()
    |> Model.build_model()
    |> Model.iterate(days)
    |> Model.count()
  end

  def part2(input, days \\ 256) do
    input
    |> parse()
    |> Model.build_model()
    |> Model.iterate(days)
    |> Model.count()
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defmodule Model do
    def build_model(input) do
      input
      |> Enum.frequencies()
    end

    defp tick({0, amount}) do
      [{6, amount}, {8, amount}]
    end

    defp tick({age, amount}) do
      [{age - 1, amount}]
    end

    defp tick_all(state) do
      state
      |> Enum.flat_map(&tick/1)
      |> Enum.reduce(%{}, fn {age, amount}, acc ->
        Map.update(acc, age, amount, &(&1 + amount))
      end)
    end

    def iterate(model, days) do
      model
      |> Stream.iterate(&tick_all/1)
      |> Enum.at(days)
    end

    def count(model) do
      model
      |> Map.values()
      |> Enum.sum()
    end
  end
end
