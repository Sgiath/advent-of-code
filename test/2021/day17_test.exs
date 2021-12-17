defmodule AdventOfCode.Year2021.Day17.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day17

  doctest AdventOfCode.Year2021.Day17

  test "part 1" do
    assert Day17.part1(Day17.test_input()) == 45
    assert Day17.part1(Day17.input()) == 30628
  end

  test "part 2" do
    assert Day17.part2(Day17.test_input()) == 112
    assert Day17.part2(Day17.input()) == 4433
  end
end
