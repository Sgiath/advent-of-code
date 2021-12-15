defmodule AdventOfCode.Year2019.Day09.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day09

  doctest AdventOfCode.Year2019.Day09

  test "part 1" do
    assert Day09.part1(Day09.input()) == 3_780_860_499
  end

  test "part 2" do
    assert Day09.part2(Day09.input()) == 33_343
  end
end
