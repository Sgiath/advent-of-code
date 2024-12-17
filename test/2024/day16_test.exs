defmodule AdventOfCode.Year2024.Day16.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day16

  doctest AdventOfCode.Year2024.Day16

  test "part 1" do
    [input1, input2] = Day16.test_input()

    assert Day16.part1(input1) == 7036
    assert Day16.part1(input2) == 11048
    assert Day16.part1(Day16.input()) == 0
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day16.part2(Day16.test_input()) == 0
    assert Day16.part2(Day16.input()) == 0
  end
end
