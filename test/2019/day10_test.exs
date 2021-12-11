defmodule AdventOfCode.Year2019.Day10.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day10

  doctest AdventOfCode.Year2019.Day10

  test "part 1" do
    assert Day10.part1(Day10.test_input()) == 210
    assert Day10.part1(Day10.input()) == 260
  end

  test "part 2" do
    assert Day10.part2(Day10.test_input()) == 802
    assert Day10.part2(Day10.input()) == 608
  end
end
