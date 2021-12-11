defmodule AdventOfCode.Year2018.Day01.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2018.Day01

  doctest AdventOfCode.Year2018.Day01

  test "part 1" do
    assert Day01.part1(Day01.test_input()) == 3
    assert Day01.part1(Day01.input()) == 543
  end

  test "part 2" do
    assert Day01.part2(Day01.test_input()) == 2
    assert Day01.part2(Day01.input()) == 621
  end
end
