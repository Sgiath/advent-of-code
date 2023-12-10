defmodule AdventOfCode.Year2023.Day09.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day09

  doctest AdventOfCode.Year2023.Day09

  test "part 1" do
    assert Day09.part1(Day09.test_input()) == 114
    assert Day09.part1(Day09.input()) == 2_043_677_056
  end

  test "part 2" do
    assert Day09.part2(Day09.test_input()) == 2
    assert Day09.part2(Day09.input()) == 1062
  end
end
