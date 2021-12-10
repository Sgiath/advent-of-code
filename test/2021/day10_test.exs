defmodule AdventOfCode.Test do
  use ExUnit.Case

  alias AdventOfCode.Year2021.Day10

  doctest AdventOfCode.Year2021.Day10

  @test_input """
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
  """

  test "part 1" do
    assert Day10.part1(@test_input) == 26397
    assert Day10.part1(Day10.input()) == 413_733
  end

  test "part 2" do
    assert Day10.part2(@test_input) == 288_957
    assert Day10.part2(Day10.input()) == 3_354_640_192
  end
end
