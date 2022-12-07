defmodule AdventOfCode.Year2022.Day07.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day07

  doctest AdventOfCode.Year2022.Day07

  test "part 1" do
    assert Day07.part1(Day07.test_input()) == 95_437
    assert Day07.part1(Day07.input()) == 1_350_966
  end

  test "part 2" do
    assert Day07.part2(Day07.test_input()) == 24_933_642
    assert Day07.part2(Day07.input()) == 6_296_435
  end
end
