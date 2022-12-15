defmodule AdventOfCode.Year2022.Day09.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day09

  doctest AdventOfCode.Year2022.Day09

  @tag skip: "not implemented"
  test "part 1" do
    assert Day09.part1(Day09.test_input()) == 13
    assert Day09.part1(Day09.input()) == 0
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day09.part2(Day09.test_input()) == 0
    assert Day09.part2(Day09.input()) == 0
  end
end
