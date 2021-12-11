defmodule AdventOfCode.Year2021.Day03.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day03

  doctest AdventOfCode.Year2021.Day03

  test "part 1" do
    assert Day03.part1(Day03.test_input()) == 198
    assert Day03.part1(Day03.input()) == 2_595_824
  end

  test "part 2" do
    assert Day03.part2(Day03.test_input()) == 230
    assert Day03.part2(Day03.input()) == 2_135_254
  end
end
