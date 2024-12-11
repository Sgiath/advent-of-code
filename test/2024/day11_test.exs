defmodule AdventOfCode.Year2024.Day11.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day11

  doctest AdventOfCode.Year2024.Day11

  test "part 1" do
    assert Day11.part1(Day11.test_input()) == 55_312
    assert Day11.part1(Day11.input()) == 216_042
  end

  test "part 2" do
    assert Day11.part2(Day11.test_input()) == 65_601_038_650_482
    assert Day11.part2(Day11.input()) == 255_758_646_442_399
  end
end
