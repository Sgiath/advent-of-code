defmodule AdventOfCode.Year2019.Day06.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2019.Day06

  doctest AdventOfCode.Year2019.Day06

  test "part 1" do
    assert Day06.part1(Day06.test_input()) == 42
    assert Day06.part1(Day06.input()) == 273_985
  end

  test "part 2" do
    test_input = """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN
    """

    assert Day06.part2(test_input) == 4
    assert Day06.part2(Day06.input()) == 460
  end
end
