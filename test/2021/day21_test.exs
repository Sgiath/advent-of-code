defmodule AdventOfCode.Year2021.Day21.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day21

  doctest AdventOfCode.Year2021.Day21

  test "part 1" do
    assert Day21.part1(Day21.test_input()) == 739_785
    assert Day21.part1(Day21.input()) == 1_196_172
  end

  test "part 2" do
    assert Day21.part2(Day21.test_input()) == 444_356_092_776_315
    assert Day21.part2(Day21.input()) == 106_768_284_484_217
  end
end
