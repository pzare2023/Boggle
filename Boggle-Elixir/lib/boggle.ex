defmodule Boggle do

  @moduledoc """
    Add your boggle function below. You may add additional helper functions if you desire.
    Test your code by running 'mix test' from the tester_ex_simple directory.
  """

  def boggle(board, words) do
    legalWords = MapSet.new(words)
    found =%{}

    iterate(board, legalWords, found, 0, 0)

  end


  def iterate(board, legalWords, found,row, col) do
    updated= dfs(board, row, col, "", [], legalWords, found)
    if row < tuple_size(board) do
      if col < tuple_size(board) do

        iterate(board, legalWords, updated, row, col + 1)
      else
        iterate(board, legalWords, updated, row + 1, 0)
      end
    else
      updated
    end
  end

  def dfs(board, row, col, curr_word, path, legalWords, found) do

    if valid(board, row, col, path) do
      new_word= curr_word <> elem(elem(board, row), col)
      new_path = path ++ [{row, col}]


      Enum.reduce(-1..1, found, fn dx, acc ->

        Enum.reduce(-1..1, acc, fn dy, acc_inner ->

          if row + dx >=0 and col + dy>=0 and row + dx < tuple_size(board) and col + dy < tuple_size(board) do

            updated=if MapSet.member?(legalWords, new_word) do
              Map.put(acc_inner, new_word, new_path)

            else
              acc_inner
            end

            dfs(board, row + dx, col + dy, new_word, new_path, legalWords, updated)
          else
            acc_inner
          end
        end)
      end)
    else
      found
    end

  end
  def valid(board, row, col, path) do
    try do
      validRow = row >=0 and row < tuple_size(board)
      if validRow do
        validCol = col >=0 and col < tuple_size(board)
        notUsed = not Enum.member?(path, {row, col})

        validRow and validCol and notUsed
      else
        false
      end
    rescue
     _ ->
      false

    end

  end
end
