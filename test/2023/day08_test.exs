defmodule AdventOfCode.Year2023.Day08.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day08

  doctest AdventOfCode.Year2023.Day08

  test "part 1" do
    assert Day08.part1(Day08.test_input1()) == 2
    assert Day08.part1(Day08.test_input2()) == 6
    assert Day08.part1(Day08.input()) == 14_893
  end

  test "part 2" do
    assert Day08.part2(Day08.test_input3()) == 6
    assert Day08.part2(Day08.input()) == 10_241_191_004_509
  end
end
