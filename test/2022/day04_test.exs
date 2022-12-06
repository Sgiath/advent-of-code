defmodule AdventOfCode.Year2022.Day04.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day04

  doctest AdventOfCode.Year2022.Day04

  test "part 1" do
    assert Day04.part1(Day04.test_input()) == 2
    assert Day04.part1(Day04.input()) == 524
  end

  test "part 2" do
    assert Day04.part2(Day04.test_input()) == 4
    assert Day04.part2(Day04.input()) == 798
  end
end
