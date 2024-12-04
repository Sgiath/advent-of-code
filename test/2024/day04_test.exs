defmodule AdventOfCode.Year2024.Day04.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day04

  doctest AdventOfCode.Year2024.Day04

  test "part 1" do
    assert Day04.part1(Day04.test_input()) == 18
    assert Day04.part1(Day04.input()) == 2633
  end

  test "part 2" do
    assert Day04.part2(Day04.test_input()) == 9
    assert Day04.part2(Day04.input()) == 1936
  end
end
