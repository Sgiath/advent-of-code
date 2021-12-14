defmodule AdventOfCode.Year2021.Day14.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day14

  doctest AdventOfCode.Year2021.Day14

  test "part 1" do
    assert Day14.part1(Day14.test_input()) == 1588
    assert Day14.part1(Day14.input()) == 2851
  end

  test "part 2" do
    assert Day14.part2(Day14.test_input()) == 2_188_189_693_529
    assert Day14.part2(Day14.input()) == 10_002_813_279_337
  end
end
