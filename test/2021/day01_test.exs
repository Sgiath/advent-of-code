defmodule AdventOfCode.Year2021.Day01.Test do
  use ExUnit.Case

  alias AdventOfCode.Year2021.Day01

  doctest AdventOfCode.Year2021.Day01

  @test_input """
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
  """

  describe "part 1" do
    test "pattern matching" do
      assert Day01.part1(@test_input) == 7
      assert Day01.part1(Day01.input()) == 1374
    end

    test "enum chunk" do
      assert Day01.part1_chunk(@test_input) == 7
      assert Day01.part1_chunk(Day01.input()) == 1374
    end
  end

  describe "part 2" do
    test "pattern matching" do
      assert Day01.part2(@test_input) == 5
      assert Day01.part2(Day01.input()) == 1418
    end

    test "enum chunk" do
      assert Day01.part2_chunk(@test_input) == 5
      assert Day01.part2_chunk(Day01.input()) == 1418
    end
  end
end
