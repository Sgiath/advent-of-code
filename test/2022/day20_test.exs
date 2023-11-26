defmodule AdventOfCode.Year2022.Day20.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day20

  doctest AdventOfCode.Year2022.Day20

  @tag skip: "not implemented"
  test "part 1" do
    assert Day20.part1(Day20.test_input()) == 3
    assert Day20.part1(Day20.input()) == 0
  end

  @tag skip: "not implemented"
  test "part 2" do
    assert Day20.part2(Day20.test_input()) == 0
    assert Day20.part2(Day20.input()) == 0
  end
end
