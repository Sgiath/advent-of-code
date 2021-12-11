defmodule AdventOfCode.Year2021.Day02.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day02

  doctest AdventOfCode.Year2021.Day02

  describe "part 1" do
    test "string" do
      assert Day02.part1(Day02.test_input()) == 150
      assert Day02.part1(Day02.input()) == 2_272_262
    end

    test "bitstring" do
      assert Day02.part1(Day02.test_input(), &Day02.count_reducer1/2) == 150
      assert Day02.part1(Day02.input(), &Day02.count_reducer1/2) == 2_272_262
    end

    test "first_letter" do
      assert Day02.part1(Day02.test_input(), &Day02.count_reducer2/2) == 150
      assert Day02.part1(Day02.input(), &Day02.count_reducer2/2) == 2_272_262
    end

    test "length" do
      assert Day02.part1(Day02.test_input(), &Day02.count_reducer3/2) == 150
      assert Day02.part1(Day02.input(), &Day02.count_reducer3/2) == 2_272_262
    end
  end

  test "part 2" do
    assert Day02.part2(Day02.test_input()) == 900
    assert Day02.part2(Day02.input()) == 2_134_882_034
  end
end
