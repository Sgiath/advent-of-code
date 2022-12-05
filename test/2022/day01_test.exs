defmodule AdventOfCode.Year2022.Day01.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day01

  doctest AdventOfCode.Year2022.Day01

  test "part 1" do
    assert Day01.part1(Day01.test_input()) == 24_000
    assert Day01.part1(Day01.input()) == 69_693
  end

  test "part 2" do
    assert Day01.part2(Day01.test_input()) == 45_000
    assert Day01.part2(Day01.input()) == 200_945
  end
end
