defmodule AdventOfCode.Year2019.Day01.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day01

  doctest AdventOfCode.Year2019.Day01

  test "part 1" do
    assert Day01.part1(Day01.test_input()) == 2 + 2 + 654 + 33_583
    assert Day01.part1(Day01.input()) == 3_315_133
  end

  test "part 2" do
    assert Day01.part2(Day01.test_input()) == 2 + 2 + 966 + 50_346
    assert Day01.part2(Day01.input()) == 4_969_831
  end
end
