defmodule AdventOfCode.Year2023.Day05.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day05

  doctest AdventOfCode.Year2023.Day05

  test "part 1" do
    assert Day05.part1(Day05.test_input()) == 35
    assert Day05.part1(Day05.input()) == 662_197_086
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day05.part2(Day05.test_input()) == 46
    assert Day05.part2(Day05.input()) == 0
  end
end
