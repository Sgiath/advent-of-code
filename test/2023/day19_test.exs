defmodule AdventOfCode.Year2023.Day19.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day19

  doctest AdventOfCode.Year2023.Day19

  test "part 1" do
    assert Day19.part1(Day19.test_input()) == 19_114
    assert Day19.part1(Day19.input()) == 406_849
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day19.part2(Day19.test_input()) == 167_409_079_868_000
    assert Day19.part2(Day19.input()) == 0
  end
end
