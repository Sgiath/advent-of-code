defmodule AdventOfCode.Year2022.Day14.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day14

  doctest AdventOfCode.Year2022.Day14

  test "part 1" do
    assert Day14.part1(Day14.test_input()) == 24
    assert Day14.part1(Day14.input()) == 994
  end

  test "part 2" do
    assert Day14.part2(Day14.test_input()) == 93
    assert Day14.part2(Day14.input()) == 26_283
  end
end
