defmodule AdventOfCode.Year2019.Day03.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day03

  doctest AdventOfCode.Year2019.Day03

  test "part 1" do
    assert Day03.part1(Day03.test_input()) == 159
    assert Day03.part1(Day03.input()) == 227
  end

  test "part 2" do
    assert Day03.part2(Day03.test_input()) == 610
    assert Day03.part2(Day03.input()) == 20_286
  end
end
