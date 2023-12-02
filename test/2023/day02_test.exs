defmodule AdventOfCode.Year2023.Day02.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day02

  doctest AdventOfCode.Year2023.Day02

  test "part 1" do
    assert Day02.part1(Day02.test_input()) == 8
    assert Day02.part1(Day02.input()) == 2720
  end

  test "part 2" do
    assert Day02.part2(Day02.test_input()) == 2286
    assert Day02.part2(Day02.input()) == 71_535
  end
end
