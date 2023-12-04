defmodule AdventOfCode.Year2023.Day04.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day04

  doctest AdventOfCode.Year2023.Day04

  test "part 1" do
    assert Day04.part1(Day04.test_input()) == 13
    assert Day04.part1(Day04.input()) == 32_609
  end

  test "part 2" do
    assert Day04.part2(Day04.test_input()) == 30
    assert Day04.part2(Day04.input()) == 14_624_680
  end
end
