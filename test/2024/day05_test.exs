defmodule AdventOfCode.Year2024.Day05.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day05

  doctest AdventOfCode.Year2024.Day05

  test "part 1" do
    assert Day05.part1(Day05.test_input()) == 143
    assert Day05.part1(Day05.input()) == 6612
  end

  test "part 2" do
    assert Day05.part2(Day05.test_input()) == 123
    assert Day05.part2(Day05.input()) == 4944
  end
end
