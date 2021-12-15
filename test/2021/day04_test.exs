defmodule AdventOfCode.Year2021.Day04.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day04

  doctest AdventOfCode.Year2021.Day04

  test "part 1" do
    assert Day04.part1(Day04.test_input()) == 4512
    assert Day04.part1(Day04.input()) == 49_686
  end

  test "part 2" do
    assert Day04.part2(Day04.test_input()) == 1924
    assert Day04.part2(Day04.input()) == 26_878
  end
end
