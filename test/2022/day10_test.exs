defmodule AdventOfCode.Year2022.Day10.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day10

  doctest AdventOfCode.Year2022.Day10

  test "part 1" do
    assert Day10.part1(Day10.test_input()) == 13_140
    assert Day10.part1(Day10.input()) == 14_760
  end
end
