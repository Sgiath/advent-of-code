defmodule AdventOfCode.Year2024.Day03.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day03

  doctest AdventOfCode.Year2024.Day03

  test "part 1" do
    assert Day03.part1(Day03.test_input()) == 161
    assert Day03.part1(Day03.input()) == 161_085_926
  end

  test "part 2" do
    assert Day03.part2(Day03.test_input()) == 48
    assert Day03.part2(Day03.input()) == 82_045_421
  end
end
