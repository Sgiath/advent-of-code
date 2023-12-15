defmodule AdventOfCode.Year2023.Day11.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day11

  doctest AdventOfCode.Year2023.Day11

  @tag skip: "not implemented"
  test "part 1" do
    assert Day11.part1(Day11.test_input()) == 374
    assert Day11.part1(Day11.input()) == 0
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day11.part2(Day11.test_input()) == 0
    assert Day11.part2(Day11.input()) == 0
  end
end
