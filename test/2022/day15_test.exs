defmodule AdventOfCode.Year2022.Day15.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day15

  doctest AdventOfCode.Year2022.Day15

  test "part 1" do
    assert Day15.part1(Day15.test_input(), 10) == 26
    assert Day15.part1(Day15.input()) == 4_717_631
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day15.part2(Day15.test_input()) == 0
    assert Day15.part2(Day15.input()) == 0
  end
end
