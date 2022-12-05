defmodule AdventOfCode.Year2022.Day03.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day03

  doctest AdventOfCode.Year2022.Day03

  test "part 1" do
    assert Day03.part1(Day03.test_input()) == 157
    assert Day03.part1(Day03.input()) == 7903
  end

  @tag :skip
  test "part 2" do
    assert Day03.part2(Day03.test_input()) == 70
    assert Day03.part2(Day03.input()) == 2548
  end
end
