defmodule AdventOfCode.Year2025.Day01.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2025.Day01

  doctest AdventOfCode.Year2025.Day01

  test "part 1" do
    assert Day01.part1(Day01.test_input()) == 3
    assert Day01.part1(Day01.input()) == 982
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day01.part2(Day01.test_input()) == 6
    assert Day01.part2(Day01.input()) == 6106
  end
end
