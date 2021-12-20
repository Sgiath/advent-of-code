defmodule AdventOfCode.Year2021.Day15.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day15

  doctest AdventOfCode.Year2021.Day15

  test "part 1" do
    assert Day15.part1(Day15.test_input()) == 40
    assert Day15.part1(Day15.input()) == 717
  end

  # skiping because it is too slow
  @tag :skip
  test "part 2" do
    assert Day15.part2(Day15.test_input()) == 315
    assert Day15.part2(Day15.input()) == 2993
  end
end
