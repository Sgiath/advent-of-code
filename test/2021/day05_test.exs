defmodule AdventOfCode.Year2021.Day05.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day05

  doctest AdventOfCode.Year2021.Day05

  test "part 1" do
    assert Day05.part1(Day05.test_input()) == 5
    assert Day05.part1(Day05.input()) == 7297
  end

  test "part 2" do
    assert Day05.part2(Day05.test_input()) == 12
    assert Day05.part2(Day05.input()) == 21_038
  end
end
