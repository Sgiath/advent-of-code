defmodule AdventOfCode.Year2019.Day08.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day08

  doctest AdventOfCode.Year2019.Day08

  test "part 1" do
    assert Day08.part1(Day08.input()) == 1596
  end
end
