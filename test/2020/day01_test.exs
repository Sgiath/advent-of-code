defmodule AdventOfCode.Year2020.Day01.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2020.Day01

  doctest AdventOfCode.Year2020.Day01

  test "part 1" do
    assert Day01.part1(Day01.test_input()) == 514_579
    assert Day01.part1(Day01.input()) == 902_451
  end

  test "part 2" do
    assert Day01.part2(Day01.test_input()) == 241_861_950
    assert Day01.part2(Day01.input()) == 85_555_470
  end
end
