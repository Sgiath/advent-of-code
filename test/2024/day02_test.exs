defmodule AdventOfCode.Year2024.Day02.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day02

  doctest AdventOfCode.Year2024.Day02

  test "part 1" do
    assert Day02.part1(Day02.test_input()) == 2
    assert Day02.part1(Day02.input()) == 359
  end

  test "part 2" do
    assert Day02.part2(Day02.test_input()) == 4
    assert Day02.part2(Day02.input()) == 418
  end
end
