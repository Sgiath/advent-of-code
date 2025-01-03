defmodule AdventOfCode.Year2023.Day15.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day15

  doctest AdventOfCode.Year2023.Day15

  test "part 1" do
    assert Day15.part1(Day15.test_input()) == 1320
    assert Day15.part1(Day15.input()) == 504_036
  end

  test "part 2" do
    assert Day15.part2(Day15.test_input()) == 145
    assert Day15.part2(Day15.input()) == 295_719
  end
end
