defmodule AdventOfCode.Year2024.Day03.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day03

  doctest AdventOfCode.Year2024.Day03

  test "part 1" do
    [input1, input2] = Day03.test_input()

    assert Day03.part1(input1) == 161
    assert Day03.part1(input2) == 161
    assert Day03.part1(Day03.input()) == 161_085_926
  end

  test "part 2" do
    [input1, input2] = Day03.test_input()

    assert Day03.part2(input1) == 161
    assert Day03.part2(input2) == 48
    assert Day03.part2(Day03.input()) == 82_045_421
  end
end
