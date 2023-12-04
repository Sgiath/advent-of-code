defmodule AdventOfCode.Year2023.Day03.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2023.Day03

  doctest AdventOfCode.Year2023.Day03

  test "part 1" do
    assert Day03.part1(Day03.test_input()) == 4361
    assert Day03.part1(Day03.input()) == 550_064
  end

  test "part 2" do
    assert Day03.part2(Day03.test_input()) == 467_835
    assert Day03.part2(Day03.input()) == 85_010_461
  end
end
