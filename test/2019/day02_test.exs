defmodule AdventOfCode.Year2019.Day02.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day02

  doctest AdventOfCode.Year2019.Day02

  test "part 1" do
    assert Day02.part1(Day02.test_input()) == 30
    assert Day02.part1(Day02.input()) == 8_017_076
  end

  test "part 2" do
    assert Day02.part2(Day02.input()) == 3146
  end
end
