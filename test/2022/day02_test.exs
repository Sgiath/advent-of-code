defmodule AdventOfCode.Year2022.Day02.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day02

  doctest AdventOfCode.Year2022.Day02

  test "part 1" do
    assert Day02.part1(Day02.test_input()) == 15
    assert Day02.part1(Day02.input()) == 11_449
  end

  test "part 2" do
    assert Day02.part2(Day02.test_input()) == 12
    assert Day02.part2(Day02.input()) == 13_187
  end
end
