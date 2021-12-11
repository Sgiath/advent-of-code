defmodule AdventOfCode.Year2019.Day07.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day07

  doctest AdventOfCode.Year2019.Day07

  test "part 1" do
    assert Day07.part1(Day07.test_input()) == 65210
    assert Day07.part1(Day07.input()) == 24625
  end

  test "part 2" do
    assert Day07.part2(Day07.test_input()) == 76543
    assert Day07.part2(Day07.input()) == 36_497_698
  end
end
