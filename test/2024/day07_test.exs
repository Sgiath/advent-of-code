defmodule AdventOfCode.Year2024.Day07.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2024.Day07

  doctest AdventOfCode.Year2024.Day07

  test "part 1" do
    assert Day07.part1(Day07.test_input()) == 3749
    assert Day07.part1(Day07.input()) == 5_702_958_180_383
  end

  test "part 2" do
    assert Day07.part2(Day07.test_input()) == 11_387
    assert Day07.part2(Day07.input()) == 92_612_386_119_138
  end
end
