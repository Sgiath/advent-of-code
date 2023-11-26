defmodule AdventOfCode.Year2022.Day17.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day17

  doctest AdventOfCode.Year2022.Day17

  test "part 1" do
    assert Day17.part1(Day17.test_input()) == 3068
    assert Day17.part1(Day17.input()) == 3151
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day17.part2(Day17.test_input()) == 1_514_285_714_288
    assert Day17.part2(Day17.input()) == 0
  end
end
