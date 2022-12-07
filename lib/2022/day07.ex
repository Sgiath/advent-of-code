defmodule AdventOfCode.Year2022.Day07 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/7
  """
  use AdventOfCode, year: 2022, day: 7
  use TypedStruct

  typedstruct module: Directory do
    field :dirs, %{String.t() => __MODULE__.t()}, default: %{}
    field :files, %{String.t() => non_neg_integer()}, default: %{}
    field :size, non_neg_integer() | :not_computed, default: :not_computed
  end

  typedstruct module: Filesystem do
    field :root, Directory.t(), default: %Directory{}
    field :wd, [String.t()], default: []
  end

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.chunk_while(
      nil,
      fn
        "$ ls", acc -> {:cont, acc, {:ls, []}}
        "$ cd " <> dir, acc -> {:cont, acc, {{:cd, dir}, []}}
        o, {command, output} -> {:cont, {command, [o | output]}}
      end,
      &{:cont, &1, []}
    )
    |> List.delete_at(0)
    |> Enum.reduce(%Filesystem{}, &apply_command/2)
    |> compute_size()
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> dir_sizes()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    fs = parse(input)
    to_delete = fs.root.size - 40_000_000

    fs
    |> dir_sizes()
    |> Enum.filter(&(&1 > to_delete))
    |> Enum.min()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  @doc ~S"""
  Apply command to filesystem
  """
  def apply_command({{:cd, "/"}, []}, %Filesystem{} = fs), do: %Filesystem{fs | wd: []}

  def apply_command({{:cd, ".."}, []}, %Filesystem{wd: [_p | wd]} = fs),
    do: %Filesystem{fs | wd: wd}

  def apply_command({{:cd, dir}, []}, %Filesystem{wd: wd} = fs),
    do: %Filesystem{fs | wd: [dir | wd]}

  def apply_command({:ls, output}, %Filesystem{} = fs) do
    Enum.reduce(output, fs, fn
      "dir " <> dir, fs ->
        put_in(fs, dir_path(fs, dir), %Directory{})

      file, fs ->
        [size, name] = String.split(file)
        put_in(fs, file_path(fs, name), String.to_integer(size))
    end)
  end

  @doc ~S"""
  Construct Access path to directory based on working directory of filesystem
  """
  def dir_path(%Filesystem{wd: wd}, dir) do
    wd
    |> Enum.reverse()
    |> Enum.reduce([:dirs, :root], &[:dirs, &1 | &2])
    |> List.insert_at(0, dir)
    |> Enum.reverse()
    |> Enum.map(&Access.key/1)
  end

  @doc ~S"""
  Construct Access path to file based on working directory of filesystem
  """
  def file_path(%Filesystem{wd: wd}, file) do
    wd
    |> Enum.reverse()
    |> Enum.reduce([:dirs, :root], &[:dirs, &1 | &2])
    |> List.replace_at(0, :files)
    |> List.insert_at(0, file)
    |> Enum.reverse()
    |> Enum.map(&Access.key/1)
  end

  @doc ~S"""
  Recursively compute size of each folder in filesystem
  """
  def compute_size(%Filesystem{root: root} = fs), do: %Filesystem{fs | root: compute_size(root)}

  def compute_size(%Directory{size: :not_computed} = dir) do
    dir = Map.update!(dir, :dirs, &Enum.map(&1, fn {name, d} -> {name, compute_size(d)} end))

    dirs_size = Enum.reduce(dir.dirs, 0, fn {_name, %{size: size}}, acc -> size + acc end)
    files_size = Enum.reduce(dir.files, 0, fn {_name, size}, acc -> size + acc end)

    Map.put(dir, :size, dirs_size + files_size)
  end

  def compute_size(dir), do: dir

  @doc ~S"""
  Extract all directory sizes from filesystem
  """
  def dir_sizes(%Filesystem{root: root}), do: List.flatten(dir_sizes(root))

  def dir_sizes(%Directory{dirs: dirs, size: size}) do
    [size | Enum.map(dirs, &dir_sizes/1)]
  end

  def dir_sizes({_name, %Directory{dirs: dirs, size: size}}) do
    [size | Enum.map(dirs, &dir_sizes/1)]
  end
end
