defmodule AdventOfCode.Year2022.Day12.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day12

  doctest AdventOfCode.Year2022.Day12

  @tag skip: "not implemented"
  test "part 1" do
    assert Day12.part1(Day12.test_input()) == 31
    assert Day12.part1(Day12.input()) == 0
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day12.part2(Day12.test_input()) == 0
    assert Day12.part2(Day12.input()) == 0
  end
end
