defmodule AdventOfCode.Year2020.Day02.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2020.Day02

  doctest AdventOfCode.Year2020.Day02

  test "part 1" do
    assert Day02.part1(Day02.test_input()) == 2
    assert Day02.part1(Day02.input()) == 550
  end

  test "part 2" do
    assert Day02.part2(Day02.test_input()) == 1
    assert Day02.part2(Day02.input()) == 634
  end
end
