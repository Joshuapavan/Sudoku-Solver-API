class Api::SudokuController < ApplicationController

def findEmptySpaces(board)
  emptySpaces = []
  for row in 0...board.length
    for column in 0...board[row].length
      if (board[row][column] == 0 || board[row][column] == nil)
        emptySpaces.push([row, column])
      end
    end
  end
  return emptySpaces
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
  lowerRow = 3 * (row / 3)
  lowerColumn = 3 * (column / 3)
  upperRow = lowerRow + 3
  upperColumn = lowerColumn + 3

  for row in lowerRow...upperRow
    for column in lowerColumn...upperColumn
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


def solveSudoku(board, emptySpacesArray)
  i = 0
  while (i < emptySpacesArray.length)
    row = emptySpacesArray[i][0]
    column = emptySpacesArray[i][1]
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
  board = params[:data]
  zero_array= findemptySpaces(board)
  solved_board = solveSudoku(board, zero_array)
  render json: {solution: solved_board.to_a.map(&:inspect)}
end

end
