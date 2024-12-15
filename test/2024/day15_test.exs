defmodule AdventOfCode.Year2024.Day15.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day15

  doctest AdventOfCode.Year2024.Day15

  test "part 1" do
    [input1, input2] = Day15.test_input()

    assert Day15.part1(input1) == 2028
    assert Day15.part1(input2) == 10092
    assert Day15.part1(Day15.input()) == 1_438_161
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day15.part2(Day15.test_input()) == 0
    assert Day15.part2(Day15.input()) == 0
  end
end
