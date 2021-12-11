defmodule AdventOfCode.Year2021.Day09.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day09

  doctest AdventOfCode.Year2021.Day09

  test "part 1" do
    assert Day09.part1(Day09.test_input()) == 15
    assert Day09.part1(Day09.input()) == 512
  end

  test "part 2" do
    assert Day09.part2(Day09.test_input()) == 1134
    assert Day09.part2(Day09.input()) == 1_600_104
  end
end
