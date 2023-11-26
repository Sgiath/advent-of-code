defmodule AdventOfCode.Year2022.Day16.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day16

  doctest AdventOfCode.Year2022.Day16

  @tag skip: "not implemented"
  test "part 1" do
    assert Day16.part1(Day16.test_input()) == 1651
    assert Day16.part1(Day16.input()) == 0
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day16.part2(Day16.test_input()) == 0
    assert Day16.part2(Day16.input()) == 0
  end
end
