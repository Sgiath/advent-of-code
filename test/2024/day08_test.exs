defmodule AdventOfCode.Year2024.Day08.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day08

  doctest AdventOfCode.Year2024.Day08

  test "part 1" do
    assert Day08.part1(Day08.test_input()) == 14
    assert Day08.part1(Day08.input()) == 348
  end

  test "part 2" do
    assert Day08.part2(Day08.test_input()) == 34
    assert Day08.part2(Day08.input()) == 1221
  end
end
