defmodule AdventOfCode.Year2025.Day02.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2025.Day02

  doctest AdventOfCode.Year2025.Day02

  test "part 1" do
    assert Day02.part1(Day02.test_input()) == 1_227_775_554
    assert Day02.part1_gen(Day02.input()) == 24_157_613_387
  end

  test "part 2" do
    assert Day02.part2(Day02.test_input()) == 4_174_379_265
    assert Day02.part2_gen(Day02.input()) == 33_832_678_380
  end
end
