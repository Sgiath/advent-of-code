defmodule AdventOfCode.Year2024.Day06.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day06

  doctest AdventOfCode.Year2024.Day06

  test "part 1" do
    assert Day06.part1(Day06.test_input()) == 41
    assert Day06.part1(Day06.input()) == 5162
  end

  test "part 2" do
    assert Day06.part2(Day06.test_input()) == 6
    assert Day06.part2(Day06.input()) == 1909
  end
end
