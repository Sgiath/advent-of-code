defmodule AdventOfCode.Year2023.Day01.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day01

  doctest AdventOfCode.Year2023.Day01

  test "part 1" do
    test_input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    assert Day01.part1(test_input) == 142
    assert Day01.part1(Day01.input()) == 54_338
  end

  test "part 2" do
    assert Day01.part2(Day01.test_input()) == 281
    assert Day01.part2(Day01.input()) == 53_389
  end
end
