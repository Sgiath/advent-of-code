defmodule AdventOfCode.Year2021.Day11.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day11

  doctest AdventOfCode.Year2021.Day11

  test "part 1" do
    assert Day11.part1(Day11.test_input()) == 1656
    assert Day11.part1(Day11.input()) == 1652
  end

  test "part 2" do
    assert Day11.part2(Day11.test_input()) == 195
    assert Day11.part2(Day11.input()) == 220
  end
end
