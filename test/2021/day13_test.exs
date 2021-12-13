defmodule AdventOfCode.Year2021.Day13.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day13

  doctest AdventOfCode.Year2021.Day13

  test "part 1" do
    assert Day13.part1(Day13.test_input()) == 17
    assert Day13.part1(Day13.input()) == 729
  end
end
