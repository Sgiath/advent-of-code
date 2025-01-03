# Advent of Code

These are my Elixir solutions for Advent of Code.

If you wanna use them for your inputs (do not recommend it, solve it yourself!)
you can save your session cookie from Advent of Code website in the `config/config.exe` or export
it into your environment (I use direnv to export it automatically):

```elixir
import Config

config :advent_of_code, session_id: "<your-session-here>"
```

Then you can run

```bash
mix advent_of_code.refresh_inputs
```

which will re-download all input files for previous years for your account. Be
aware that tests won't work because the results are hardcoded for my inputs.

You can run any task you want with this command:

```bash
mix advent_of_code --year <year> --day <day> --part1 --part2
```

If you want to solve the task yourself you can delete my file (don't worry it
is still in git so you can restore it whenever you want) and run this command:

```bash
mix advent_of_code.init --year <year> --day <day>
```

You would run the same command if you would like to solve some task I didn't yet
solve.

During development the `--test` flag can be handy - it runs the task with test
input instead so it is easier to debug.

```bash
mix advent_of_code --year <year> --day <day> --part1 --part2 --test
```

If you would like to see how fast the solutions are you can run the included
benchmarks. By default it will just run the solutions side by side but if you
develop different solutions you can override the `benchmark/0` function for any
day and run different solutions side by side (see `/lib/2021/day06.ex:156` for
example)

```bash
mix advent_of_code.bench --year <year> --day <day>
```

If you have a solution but you want find out where is the majority of time spent you can profile
your solution with this command:

```bash
mix advent_of_code.profile --year <year> --day <day> --part1 --part2
```

All commands have default values for year and day set to current year (if current month is
December otherwise it is last year) and day so if you are solving the tasks same day they are
published you can omit those arguments.
