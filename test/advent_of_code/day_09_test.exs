defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "part1" do
    input = "2199943210\n3987894921\n9856789892\n8767896789\n9899965678"
    result = part1(input)

    assert result == 15
  end

  test "part2" do
    input = "2199943210\n3987894921\n9856789892\n8767896789\n9899965678"
    result = part2(input)

    assert result == 1134
  end
end
