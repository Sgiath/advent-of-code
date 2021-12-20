defmodule AdventOfCode.Year2021.Day18 do
  @moduledoc """
  https://adventofcode.com/2021/day/18
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day18.in"])
    |> File.read!()
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&(&1 |> Code.eval_string() |> elem(0) |> tree()))
  end

  @doc """
  Construct tree - convert lists to tuples
  """
  def tree([a, b]), do: {tree(a), tree(b)}
  def tree(a), do: a

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.reduce(&reduce({&2, &1}))
    |> magnitude()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    numbers = parse(input)

    for number1 <- numbers, number2 <- numbers, number1 !== number2 do
      [reduce({number1, number2}), reduce({number2, number1})]
    end
    |> List.flatten()
    |> Enum.map(&magnitude/1)
    |> Enum.max()
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Go through tree and first explode everything and than split everything
  """
  def reduce(tree), do: explode(tree)

  @doc """
  Go through tree find next explosion, explode and restart
  When no explosion is found do split
  """
  def explode(tree, path \\ [0])
  def explode(tree, []), do: split(tree)

  def explode(tree, [_first | path]) when length(path) > 3,
    do: tree |> do_explode(path) |> explode()

  def explode(tree, path) do
    case access(tree, path) do
      node when is_tuple(node) -> explode(tree, [0 | path])
      node when is_integer(node) -> explode(tree, move_right(path))
    end
  end

  @doc """
  Go through tree, find next split, split and do explode
  """
  def split(tree, path \\ [0])
  def split(tree, []), do: tree

  def split(tree, path) do
    case access(tree, path) do
      node when is_integer(node) and node >= 10 -> tree |> do_split(path) |> explode()
      _node -> split(tree, next(tree, path))
    end
  end

  @doc """
  Get the next node

  - right neighbour if current is left leaf
  - left child if current is not leaf
  - otherwise traverse up the tree to find next right node
  """
  def next(tree, [first | rest] = path) do
    case access(tree, path) do
      node when is_integer(node) and first === 0 -> [1 | rest]
      node when is_tuple(node) -> [0 | path]
      _node -> move_right(rest)
    end
  end

  @doc """
  Access the node value based on path
  """
  def access(tree, path) do
    get_in(tree, path |> Enum.reverse() |> Enum.map(&Access.elem/1))
  end

  @doc """
  Add value to the node
  """
  def add(tree, [], _val), do: tree

  def add(tree, path, val) do
    update_in(tree, path |> Enum.reverse() |> Enum.map(&Access.elem/1), &(&1 + val))
  end

  @doc """
  Set value for the node
  """
  def set(tree, path, val) do
    put_in(tree, path |> Enum.reverse() |> Enum.map(&Access.elem/1), val)
  end

  @doc """
  Move to the next right node

  - right neighbor if current is left neighbor
  - go up and repeat if current is right node
  """
  def move_right([0 | rest]), do: [1 | rest]
  def move_right([1 | rest]), do: move_right(rest)
  def move_right([]), do: []

  @doc """
  Get closes left leaf from the path
  """
  def left_leaf(tree, [1 | path]), do: find_left(tree, [0 | path])
  def left_leaf(tree, [0 | path]), do: left_leaf(tree, path)
  def left_leaf(_tree, []), do: []

  def find_left(tree, path) do
    case access(tree, path) do
      node when is_tuple(node) -> find_left(tree, [1 | path])
      node when is_integer(node) -> path
    end
  end

  @doc """
  Get closes right leaf from the path
  """
  def right_leaf(tree, [0 | path]), do: find_right(tree, [1 | path])
  def right_leaf(tree, [1 | path]), do: right_leaf(tree, path)
  def right_leaf(_tree, []), do: []

  def find_right(tree, path) do
    case access(tree, path) do
      node when is_tuple(node) -> find_right(tree, [0 | path])
      node when is_integer(node) -> path
    end
  end

  @doc """
  Do the explosion
  """
  def do_explode(tree, path) do
    {a, b} = access(tree, path)

    tree
    |> add(left_leaf(tree, path), a)
    |> add(right_leaf(tree, path), b)
    |> set(path, 0)
  end

  @doc """
  Do the split
  """
  def do_split(tree, path) do
    val = access(tree, path) / 2

    set(tree, path, {floor(val), ceil(val)})
  end

  @doc """
  Comupes magnitude of a number

  ## Examples

      iex> AdventOfCode.Year2021.Day18.magnitude({{1,2},{{3,4},5}})
      143
      iex> AdventOfCode.Year2021.Day18.magnitude({{{{0,7},4},{{7,8},{6,0}}},{8,1}})
      1384
      iex> AdventOfCode.Year2021.Day18.magnitude({{{{1,1},{2,2}},{3,3}},{4,4}})
      445
      iex> AdventOfCode.Year2021.Day18.magnitude({{{{3,0},{5,3}},{4,4}},{5,5}})
      791
      iex> AdventOfCode.Year2021.Day18.magnitude({{{{5,0},{7,4}},{5,5}},{6,6}})
      1137
      iex> AdventOfCode.Year2021.Day18.magnitude({{{{8,7},{7,7}},{{8,6},{7,7}}},{{{0,7},{6,6}},{8,7}}})
      3488
  """
  def magnitude({left, right}), do: 3 * magnitude(left) + 2 * magnitude(right)
  def magnitude(number) when is_integer(number), do: number
end
