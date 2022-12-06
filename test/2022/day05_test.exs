defmodule AdventOfCode.Year2022.Day05.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day05

  doctest AdventOfCode.Year2022.Day05

  test "part 1" do
    assert Day05.part1(Day05.test_input()) == "CMZ"
    assert Day05.part1(Day05.input()) == "VPCDMSLWJ"
  end

  test "part 2" do
    assert Day05.part2(Day05.test_input()) == "MCD"
    assert Day05.part2(Day05.input()) == "TPWCGNCCG"
  end
end
