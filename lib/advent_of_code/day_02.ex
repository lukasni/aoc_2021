defmodule AdventOfCode.Day02 do
  @moduledoc """
  Your horizontal position and depth both start at 0. The steps above would then modify them as follows:

  forward 5 adds 5 to your horizontal position, a total of 5.
  down 5 adds 5 to your depth, resulting in a value of 5.
  forward 8 adds 8 to your horizontal position, a total of 13.
  up 3 decreases your depth by 3, resulting in a value of 2.
  down 8 adds 8 to your depth, resulting in a value of 10.
  forward 2 adds 2 to your horizontal position, a total of 15.

  After following these instructions, you would have a horizontal position of 15 and a depth of 10. (Multiplying these together produces 150.)

  Calculate the horizontal position and depth you would have after following the planned course. What do you get if you multiply your final horizontal position by your final depth?
  """
  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce({0,0}, &execute_instruction/2)
    |> Tuple.product()
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce({0,0,0}, &execute_instruction_2/2)
    |> Tuple.delete_at(2)
    |> Tuple.product()
  end

  defp parse_instruction(instruction) do
    [direction, magnitude] = String.split(instruction, " ")

    {String.to_existing_atom(direction), String.to_integer(magnitude)}
  end

  defp execute_instruction({direction, magnitude}, {position, depth}) do
    case direction do
      :forward ->
        {position+magnitude, depth}

      :up ->
        {position, depth-magnitude}

      :down ->
        {position, depth+magnitude}
    end
  end

  defp execute_instruction_2({direction, magnitude}, {position, depth, aim}) do
    case direction do
      :forward ->
        {position+magnitude, depth+(aim*magnitude), aim}

      :up ->
        {position, depth, aim-magnitude}

      :down ->
        {position, depth, aim+magnitude}
    end
  end
end
