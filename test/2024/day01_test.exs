defmodule AdventOfCode.Year2024.Day01.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day01

  doctest AdventOfCode.Year2024.Day01

  test "part 1" do
    assert Day01.part1(Day01.test_input()) == 11
    assert Day01.part1(Day01.input()) == 936_063
  end

  test "part 2" do
    assert Day01.part2(Day01.test_input()) == 31
    assert Day01.part2(Day01.input()) == 23_150_395
  end
end
