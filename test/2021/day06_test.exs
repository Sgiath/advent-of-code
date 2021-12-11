defmodule AdventOfCode.Year2021.Day06.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day06

  doctest AdventOfCode.Year2021.Day06

  describe "part 1" do
    test "recursion" do
      assert Day06.part1(Day06.test_input()) == 5934
      assert Day06.part1(Day06.input()) == 395_627
    end

    test "matrix" do
      assert Day06.matrix_80(Day06.test_input()) == 5934
      assert Day06.matrix_80(Day06.input()) == 395_627
    end
  end

  describe "part 2" do
    test "recursion" do
      assert Day06.part2(Day06.test_input()) == 26_984_457_539
      assert Day06.part2(Day06.input()) == 1_767_323_539_209
    end

    test "matrix" do
      assert Day06.matrix_256(Day06.test_input()) == 26_984_457_539
      assert Day06.matrix_256(Day06.input()) == 1_767_323_539_209
    end
  end
end
