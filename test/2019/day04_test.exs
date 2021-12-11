defmodule AdventOfCode.Year2019.Day04.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day04

  doctest AdventOfCode.Year2019.Day04

  test "part 1" do
    assert Day04.part1(Day04.input()) == 2220
  end

  test "part 2" do
    assert Day04.part2(Day04.input()) == 1515
  end
end
