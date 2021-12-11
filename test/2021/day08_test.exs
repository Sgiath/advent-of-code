defmodule AdventOfCode.Year2021.Day08.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day08

  doctest AdventOfCode.Year2021.Day08

  test "part 1" do
    assert Day08.part1(Day08.test_input()) == 26
    assert Day08.part1(Day08.input()) == 470
  end

  test "part 2" do
    assert Day08.part2(Day08.test_input()) == 61229
    assert Day08.part2(Day08.input()) == 989_396
  end
end
