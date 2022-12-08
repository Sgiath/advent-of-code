defmodule AdventOfCode.Year2022.Day08.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day08

  doctest AdventOfCode.Year2022.Day08

  test "part 1" do
    assert Day08.part1(Day08.test_input()) == 21
    assert Day08.part1(Day08.input()) == 1695
  end

  test "part 2" do
    assert Day08.part2(Day08.test_input()) == 8
    assert Day08.part2(Day08.input()) == 287_040
  end
end
