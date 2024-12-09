defmodule AdventOfCode.Year2024.Day09.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day09

  doctest AdventOfCode.Year2024.Day09

  test "part 1" do
    assert Day09.part1(Day09.test_input()) == 1928
    assert Day09.part1(Day09.input()) == 6_366_665_108_136
  end

  test "part 2" do
    assert Day09.part2(Day09.test_input()) == 2858
    assert Day09.part2(Day09.input()) == 6_398_065_450_842
  end
end
