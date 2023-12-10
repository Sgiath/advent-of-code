defmodule AdventOfCode.Year2023.Day01.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day01

  doctest AdventOfCode.Year2023.Day01

  test "part 1" do
    assert Day01.part1(Day01.test_input1()) == 142
    assert Day01.part1(Day01.input()) == 54_338
  end

  test "part 2" do
    assert Day01.part2(Day01.test_input2()) == 281
    assert Day01.part2(Day01.input()) == 53_389
  end
end
