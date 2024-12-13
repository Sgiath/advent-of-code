defmodule AdventOfCode.Year2024.Day13.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day13

  doctest AdventOfCode.Year2024.Day13

  test "part 1" do
    assert Day13.part1(Day13.test_input()) == 480
    assert Day13.part1(Day13.input()) == 35574
  end

  test "part 2" do
    assert Day13.part2(Day13.test_input()) == 875_318_608_908
    assert Day13.part2(Day13.input()) == 80_882_098_756_071
  end
end
