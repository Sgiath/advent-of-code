defmodule AdventOfCode.Year2022.Day13.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day13

  doctest AdventOfCode.Year2022.Day13

  test "part 1" do
    assert Day13.part1(Day13.test_input()) == 13
    assert Day13.part1(Day13.input()) == 6086
  end

  test "part 2" do
    assert Day13.part2(Day13.test_input()) == 140
    assert Day13.part2(Day13.input()) == 27_930
  end
end
