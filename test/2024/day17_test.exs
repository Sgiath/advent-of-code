defmodule AdventOfCode.Year2024.Day17.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day17

  doctest AdventOfCode.Year2024.Day17

  test "part 1" do
    input1 =
      """
      Register A: 729
      Register B: 0
      Register C: 0

      Program: 0,1,5,4,3,0
      """

    assert Day17.part1(input1) == "4,6,3,5,6,3,5,2,1,0"
    assert Day17.part1(Day17.test_input()) == "5,7,3,0"
    assert Day17.part1(Day17.input()) == "6,7,5,2,1,3,5,1,7"
  end

  test "part 2" do
    assert Day17.part2(Day17.test_input()) == 117_440

    # this is too slow
    # assert Day17.part2(Day17.input()) == 0
  end
end
