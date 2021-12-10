defmodule AdventOfCode.Year2021.Day07.Test do
  use ExUnit.Case

  alias AdventOfCode.Year2021.Day07

  doctest AdventOfCode.Year2021.Day07

  @test_input """
  16,1,2,0,4,2,7,1,2,14
  """

  test "part 1" do
    assert Day07.part1(@test_input) == 37
    assert Day07.part1(Day07.input()) == 344_535
  end

  test "part 2" do
    assert Day07.part2(@test_input) == 168
    assert Day07.part2(Day07.input()) == 95_581_659
  end
end
