defmodule AdventOfCode.Year2020.Day03.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2020.Day03

  doctest AdventOfCode.Year2020.Day03

  test "part 1" do
    assert Day03.part1(Day03.test_input()) == 7
    assert Day03.part1(Day03.input()) == 214
  end

  test "part 2" do
    assert Day03.part2(Day03.test_input()) == 336
    assert Day03.part2(Day03.input()) == 8_336_352_024
  end
end
