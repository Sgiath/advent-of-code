defmodule AdventOfCode.Year2022.Day11.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day11

  doctest AdventOfCode.Year2022.Day11

  test "part 1" do
    assert Day11.part1(Day11.test_input()) == 10_605
    assert Day11.part1(Day11.input()) == 50_616
  end

  @tag skip: "too slow"
  test "part 2" do
    assert Day11.part2(Day11.test_input()) == 2_713_310_158
    assert Day11.part2(Day11.input()) == 11_309_046_332
  end
end
