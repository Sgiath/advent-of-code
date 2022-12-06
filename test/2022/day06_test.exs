defmodule AdventOfCode.Year2022.Day06.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2022.Day06

  doctest AdventOfCode.Year2022.Day06

  test "part 1" do
    assert Day06.part1(Day06.test_input()) == 7
    assert Day06.part1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
    assert Day06.part1("nppdvjthqldpwncqszvftbrmjlhg") == 6
    assert Day06.part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
    assert Day06.part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
    assert Day06.part1(Day06.input()) == 1538
  end

  test "part 2" do
    assert Day06.part2(Day06.test_input()) == 19
    assert Day06.part2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
    assert Day06.part2("nppdvjthqldpwncqszvftbrmjlhg") == 23
    assert Day06.part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
    assert Day06.part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
    assert Day06.part2(Day06.input()) == 2315
  end
end
