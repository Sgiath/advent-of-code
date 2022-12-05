defmodule AdventOfCode.Year2021.Day20.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day20

  doctest AdventOfCode.Year2021.Day20

  test "part 1" do
    assert Day20.part1(Day20.test_input()) == 35
    assert Day20.part1(Day20.input()) == 5349
  end

  # skipping because it is too slow
  @tag :skip
  test "part 2" do
    assert Day20.part2(Day20.test_input()) == 3351
    assert Day20.part2(Day20.input()) == 15_806
  end
end
