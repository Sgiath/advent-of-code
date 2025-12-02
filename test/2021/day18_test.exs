defmodule AdventOfCode.Year2021.Day18.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day18

  doctest AdventOfCode.Year2021.Day18

  test "part 1" do
    assert Day18.part1(Day18.test_input()) == 4140
    assert Day18.part1(Day18.input()) == 3806
  end

  test "part 2" do
    assert Day18.part2(Day18.test_input()) == 3993
    assert Day18.part2(Day18.input()) == 4727
  end
end
