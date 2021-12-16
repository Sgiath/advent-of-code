defmodule AdventOfCode.Year2021.Day16.Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Year2021.Day16

  doctest AdventOfCode.Year2021.Day16

  test "part 1" do
    assert Day16.part1("D2FE28") == 6
    assert Day16.part1("38006F45291200") == 9
    assert Day16.part1("EE00D40C823060") == 14
    assert Day16.part1("8A004A801A8002F478") == 16
    assert Day16.part1("620080001611562C8802118E34") == 12
    assert Day16.part1("C0015000016115A2E0802F182340") == 23
    assert Day16.part1("A0016C880162017C3686B18A3D4780") == 31
    assert Day16.part1(Day16.input()) == 920
  end

  test "part 2" do
    assert Day16.part2("C200B40A82") == 3
    assert Day16.part2("04005AC33890") == 54
    assert Day16.part2("880086C3E88112") == 7
    assert Day16.part2("CE00C43D881120") == 9
    assert Day16.part2("D8005AC2A8F0") == 1
    assert Day16.part2("F600BC2D8F") == 0
    assert Day16.part2("9C005AC2F8F0") == 0
    assert Day16.part2("9C0141080250320F1802104A08") == 1
    assert Day16.part2(Day16.input()) == 10_185_143_721_112
  end
end
