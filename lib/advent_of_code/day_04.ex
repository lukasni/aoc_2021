defmodule AdventOfCode.Day04 do
  alias __MODULE__.BingoBoard

  def part1(input) do
    [chosen_numbers_string | board_numbers] = String.split(input)

    chosen_numbers =
      chosen_numbers_string
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards = BingoBoard.from_input_list(board_numbers)

    chosen_numbers
    |> Enum.reduce_while(boards, &play_game_1/2)
  end

  defp play_game_1(number, boards) do
    new_boards =
      boards
      |> Enum.map(&BingoBoard.mark(&1, number))

    case Enum.find(new_boards, &(&1.win)) do
      nil ->
        {:cont, new_boards}
      board ->
        {:halt, BingoBoard.score(board) * number}
    end
  end

  def part2(input) do
    [chosen_numbers_string | board_numbers] = String.split(input)

    chosen_numbers =
      chosen_numbers_string
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards = BingoBoard.from_input_list(board_numbers)

    chosen_numbers
    |> Enum.reduce_while(boards, &play_game_2/2)
  end

  defp play_game_2(number, boards) do
    new_boards =
      boards
      |> Enum.map(&BingoBoard.mark(&1, number))

    case new_boards do
      [%{win: true} = board] ->
        {:halt, number * BingoBoard.score(board)}
      new_boards ->
        {:cont, Enum.reject(new_boards, &(&1.win))}
    end
  end

  defmodule BingoBoard do
    @board_size 5

    defstruct rows: [],
              win: false

    def from_input_list(board_numbers) do
      board_numbers
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(fn num -> {num, :unmarked} end)
      |> Enum.chunk_every(@board_size * @board_size)
      |> Enum.map(&Enum.chunk_every(&1, @board_size))
      |> Enum.map(&struct(__MODULE__, rows: &1))
    end

    def new(rows) do
      struct(__MODULE__, rows: rows)
    end

    def mark(board, number) do
      board.rows
      |> List.flatten()
      |> Enum.map(fn {num, is_marked?} ->
        case num do
          ^number ->
            {num, :marked}
          _ ->
            {num, is_marked?}
        end
      end)
      |> Enum.chunk_every(@board_size)
      |> new()
      |> check_win()
    end

    def check_win(%BingoBoard{win: true} = board) do
      board
    end

    def check_win(board) do
      with false <- do_check_win(board),
           false <- do_check_win(transpose(board)) do
        board
      else
        true ->
          %{board | win: true}
      end
    end

    def do_check_win(board) do
      board.rows
      |> Enum.any?(fn row ->
        Enum.all?(row, fn {_, is_marked?} -> is_marked? == :marked end)
      end)
    end

    def transpose(board) do
      board.rows
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> new()
    end

    def score(board) do
      board.rows
      |> List.flatten()
      |> Enum.reduce(0, fn {num, is_marked?}, acc ->
        case is_marked? do
          :unmarked ->
            acc + num
          :marked ->
            acc
        end
      end)
    end
  end
end
