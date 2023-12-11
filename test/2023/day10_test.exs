defmodule AdventOfCode.Year2023.Day10.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day10

  doctest AdventOfCode.Year2023.Day10

  test "part 1" do
    assert Day10.part1(Day10.test_input1()) == 4
    assert Day10.part1(Day10.test_input2()) == 8
    assert Day10.part1(Day10.input()) == 7066
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day10.part2(Day10.test_input3()) == 4
    assert Day10.part2(Day10.test_input4()) == 8
    assert Day10.part2(Day10.test_input5()) == 10
    assert Day10.part2(Day10.input()) == 0
  end
end
