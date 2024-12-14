defmodule AdventOfCode.Year2024.Day14.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day14

  doctest AdventOfCode.Year2024.Day14

  test "part 1" do
    assert Day14.part1(Day14.test_input(), {11, 7}) == 12
    assert Day14.part1(Day14.input()) == 230461440
  end

  @tag skip: "visual puzzle"
  test "part 2" do
    assert Day14.part2(Day14.input()) == 6668
  end
end
