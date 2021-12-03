defmodule AdventOfCode.Year2019.Day10 do
  @moduledoc """
  https://adventofcode.com/2019/day/10
  """
  use AdventOfCode, year: 2019, day: 10

  @type asteroid_map() :: list(list(char()))
  @type point() :: {integer(), integer()}

  @impl AdventOfCode
  def input, do: input_chars()

  @impl AdventOfCode
  def part1(input) do
    input
    |> get_best()
    |> elem(0)
  end

  @impl AdventOfCode
  def part2(input) do
    {_, anchor} = get_best(input)

    {{x, y}, _angle, _distance} =
      input
      |> get_asteroids()
      |> Enum.reverse()
      |> List.delete(anchor)
      |> Enum.map(&(&1 |> compute_angle(anchor) |> compute_distance(anchor)))
      |> Enum.group_by(fn {_point, angle, _distance} -> angle end)
      |> Enum.sort_by(fn {angle, _points} -> angle end)
      |> Enum.map(fn {_angle, points} ->
        Enum.min_by(points, fn {_point, _angle, distance} -> distance end)
      end)
      |> Enum.at(199)

    x * 100 + y
  end

  @spec get_asteroids(Enumerable.t()) :: list(point())
  def get_asteroids(asteroid_map) do
    asteroid_map
    |> Stream.map(&Enum.with_index(&1, 0))
    |> Stream.with_index(0)
    |> Enum.reduce([], fn {list, y}, acc ->
      Enum.reduce(list, [], fn
        {"#", x}, acc2 -> [{x, y} | acc2]
        _pos, acc2 -> acc2
      end) ++ acc
    end)
  end

  @spec compute_angle(point(), point()) :: {point(), number()}
  def compute_angle({x, y}, {x, a_y}) when y <= a_y do
    {{x, y}, 0}
  end

  def compute_angle({x, y}, {x, a_y}) when y > a_y do
    {{x, y}, :math.pi()}
  end

  def compute_angle({x, y}, {a_x, y}) when x > a_x do
    {{x, y}, :math.pi() / 2}
  end

  def compute_angle({x, y}, {a_x, y}) when x < a_x do
    {{x, y}, :math.pi() * (3 / 2)}
  end

  def compute_angle({x, y}, {a_x, a_y}) when x > a_x and y < a_y do
    opposite = abs(a_x - x)
    adjacent = abs(a_y - y)
    angle = :math.atan2(opposite, adjacent)

    {{x, y}, angle}
  end

  def compute_angle({x, y}, {a_x, a_y}) when x > a_x and y > a_y do
    opposite = abs(y - a_y)
    adjacent = abs(x - a_x)
    angle = :math.atan2(opposite, adjacent) + :math.pi() / 2

    {{x, y}, angle}
  end

  def compute_angle({x, y}, {a_x, a_y}) when x < a_x and y > a_y do
    opposite = abs(x - a_x)
    adjacent = abs(y - a_y)
    angle = :math.atan2(opposite, adjacent) + :math.pi()

    {{x, y}, angle}
  end

  def compute_angle({x, y}, {a_x, a_y}) when x < a_x and y < a_y do
    opposite = abs(a_x - x)
    adjacent = abs(a_y - y)
    angle = 2 * :math.pi() - :math.atan2(opposite, adjacent)

    {{x, y}, angle}
  end

  @spec compute_distance({point(), number()}, point()) :: {point(), number(), number()}
  def compute_distance({{x, y}, angle}, {x, a_y}), do: {{x, y}, angle, abs(a_y - y)}
  def compute_distance({{x, y}, angle}, {a_x, y}), do: {{x, y}, angle, abs(a_x - x)}

  def compute_distance({{x, y}, angle}, {a_x, a_y}) do
    distance = :math.sqrt(:math.pow(x - a_x, 2) + :math.pow(y - a_y, 2))

    {{x, y}, angle, distance}
  end

  @spec get_best(Enumerable.t()) :: {integer(), point()}
  def get_best(asteroid_map) do
    asteroid_map = Enum.to_list(asteroid_map)

    x_size = length(List.first(asteroid_map))
    y_size = length(asteroid_map)

    all_asteroids =
      for x <- 0..(x_size - 1),
          y <- 0..(y_size - 1),
          is_asteroid?(asteroid_map, {x, y}),
          do: {x, y}

    all_asteroids
    |> Enum.map(&get_visible(asteroid_map, &1, all_asteroids))
    |> Enum.max_by(fn {num, _} -> num end)
  end

  def get_visible(map, anchor, all_asteroids) do
    num =
      map
      |> mark_all_hidden(anchor, all_asteroids)
      |> List.flatten()
      |> Enum.count(&(&1 == "#"))
      |> Kernel.-(1)

    {num, anchor}
  end

  @spec mark_all_hidden(asteroid_map(), point(), list(point())) :: asteroid_map()
  def mark_all_hidden(map, anchor, all_asteroids) do
    all_asteroids
    |> Enum.filter(&(&1 != anchor))
    |> Enum.reduce(map, &mark_hidden(&2, anchor, &1))
  end

  @spec is_asteroid?(asteroid_map(), point()) :: boolean()
  def is_asteroid?(map, {x, y}) do
    Enum.at(Enum.at(map, y), x) == "#"
  end

  @spec mark_hidden(asteroid_map(), point(), point()) :: asteroid_map()
  def mark_hidden(map, anchor, asteroid) do
    x_length = length(List.first(map))
    y_length = length(map)

    anchor
    |> get_hidden(asteroid, {x_length, y_length})
    |> Enum.reduce(map, fn {x, y}, map ->
      List.update_at(map, y, fn row ->
        List.update_at(row, x, fn _value -> "H" end)
      end)
    end)
  end

  @doc """
  iex> AdventOfCode.Year2019.Day10.get_hidden({0, 0}, {3, 1}, {10, 10})
  [{9, 3}, {6, 2}]

  iex> AdventOfCode.Year2019.Day10.get_hidden({0, 0}, {3, 2}, {10, 10})
  [{9, 6}, {6, 4}]

  iex> AdventOfCode.Year2019.Day10.get_hidden({0, 0}, {3, 3}, {10, 10})
  [{9, 9}, {8, 8}, {7, 7}, {6, 6}, {5, 5}, {4, 4}]

  iex> AdventOfCode.Year2019.Day10.get_hidden({0, 0}, {2, 3}, {10, 10})
  [{6, 9}, {4, 6}]

  iex> AdventOfCode.Year2019.Day10.get_hidden({0, 0}, {1, 3}, {10, 10})
  [{3, 9}, {2, 6}]

  iex> AdventOfCode.Year2019.Day10.get_hidden({0, 0}, {2, 4}, {10, 10})
  [{4, 8}, {3, 6}]

  iex> AdventOfCode.Year2019.Day10.get_hidden({0, 0}, {4, 3}, {10, 10})
  [{8, 6}]
  """
  @spec get_hidden(point(), point(), point()) :: list(point())
  def get_hidden({x_anchor, y_anchor}, {x_asteroid, y_asteroid}, size) do
    x_diff = x_asteroid - x_anchor
    y_diff = y_asteroid - y_anchor

    gen_coord({x_asteroid, y_asteroid}, normalize(x_diff, y_diff), size)
  end

  defp normalize(x, y) do
    gcd = Integer.gcd(x, y)
    {div(x, gcd), div(y, gcd)}
  end

  @spec gen_coord(point(), point(), point(), list(point())) :: list(point())
  def gen_coord({x_anchor, y_anchor}, {x_diff, y_diff}, {x_size, y_size}, res \\ []) do
    x_new = x_anchor + x_diff
    y_new = y_anchor + y_diff

    if 0 <= x_new and x_new < x_size and 0 <= y_new and y_new < y_size do
      gen_coord({x_new, y_new}, {x_diff, y_diff}, {x_size, y_size}, [{x_new, y_new} | res])
    else
      res
    end
  end
end
