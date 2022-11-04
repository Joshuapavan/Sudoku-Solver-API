class Api::SudokuController < ApplicationController

def findZeros(board)
  zeros = []
  for row in 0...board.length
    for column in 0...board[row].length
      if (board[row][column] == 0 || board[row][column] == "null")
        zeros << [row, column]
      end
    end
  end
  return zeros
end

def isNumberInRow(board, row, number)
  for column in 0...board[row].length
    if (board[row][column] == number)
      return false
    end
  end
  return true
end


def isNumberInColumn(board, column, number)
  for row in 0...board.length
    if (board[row][column] == number)
      return false
    end
  end
  return true
end

def isNumberInBlock(board, row, column, number)
  lower_row = 3 * (row / 3)
  lower_column = 3 * (column / 3)
  upper_row = lower_row + 3
  upper_column = lower_column + 3

  for row in lower_row...upper_row
    for column in lower_column...upper_column
      if (board[row][column] == number)
        return false
      end
    end
  end
  return true
end



def isValidPlacement(board, row, column, number)
  return (
    isNumberInRow(board, row, number) &&
    isNumberInColumn(board, column, number) &&
    isNumberInBlock(board, row, column, number)
  )
end


def solveSudoku(board, zeros)
  i = 0
  while (i < zeros.length)
    row = zeros[i][0]
    column = zeros[i][1]
    number = board[row][column] + 1
    found = false

    while (!found && number <= 9)
      if(isValidPlacement(board, row, column, number))
        found = true
        board[row][column] = number
        i += 1
      else
        number += 1
      end
    end

    if !found
      board[row][column] = 0
      i -= 1
    end

  end
  return board
end

def solve
  board = params[:data].to_a
  zero_array= findZeros(board)
  solved_board = solveSudoku(board, zero_array)
  render json: {solution: solved_board.to_a.map(&:inspect)}
end

end
