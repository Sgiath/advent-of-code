defmodule AdventOfCode.Year2021.Day12.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day12

  doctest AdventOfCode.Year2021.Day12

  @larger_test """
  dc-end
  HN-start
  start-kj
  dc-start
  dc-HN
  LN-dc
  HN-end
  kj-sa
  kj-HN
  kj-dc
  """

  @large_test """
  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW
  """

  describe "part 1" do
    test "small test" do
      assert Day12.part1(Day12.test_input()) == 10
    end

    test "larger test" do
      assert Day12.part1(@larger_test) == 19
    end

    test "large test" do
      assert Day12.part1(@large_test) == 226
    end

    test "live data" do
      assert Day12.part1(Day12.input()) == 4754
    end
  end

  describe "part 2" do
    test "small test" do
      assert Day12.part2(Day12.test_input()) == 36
    end

    test "larger test" do
      assert Day12.part2(@larger_test) == 103
    end

    test "large test" do
      assert Day12.part2(@large_test) == 3509
    end

    test "live data" do
      assert Day12.part2(Day12.input()) == 143_562
    end
  end
end
