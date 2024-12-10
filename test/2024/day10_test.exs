defmodule AdventOfCode.Year2024.Day10.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day10

  doctest AdventOfCode.Year2024.Day10

  test "part 1" do
    assert Day10.part1(Day10.test_input()) == 36
    assert Day10.part1(Day10.input()) == 811
  end

  test "part 2" do
    assert Day10.part2(Day10.test_input()) == 81
    assert Day10.part2(Day10.input()) == 1794
  end
end
