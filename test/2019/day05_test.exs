defmodule AdventOfCode.Year2019.Day05.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day05

  doctest AdventOfCode.Year2019.Day05

  test "part 1" do
    assert Day05.part1(Day05.input()) == 13_346_482
  end

  test "part 2" do
    assert Day05.part2(Day05.test_input()) == 999
    assert Day05.part2(Day05.input()) == 12_111_395
  end
end
