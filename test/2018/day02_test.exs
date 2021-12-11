defmodule AdventOfCode.Year2018.Day02.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2018.Day02

  doctest AdventOfCode.Year2018.Day02

  test "part 1" do
    assert Day02.part1(Day02.test_input()) == 12
    assert Day02.part1(Day02.input()) == 8118
  end

  test "part 2" do
    assert Day02.part2(Day02.test_input()) == "abcde"
    assert Day02.part2(Day02.input()) == "jbbenqtlaxhivmwyscjukztdp"
  end
end
