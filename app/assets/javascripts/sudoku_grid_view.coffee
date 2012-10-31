class SudokuGridView
  displayGrid: (sudoku_grid) ->
    for i in [0..8]
      for j in [0..8]
        if sudoku_grid.getMove(i, j) == 0
          $("#box_#{i}_#{j}").text('')
        else
          $("#box_#{i}_#{j}").text(sudoku_grid.getMove(i, j))

window.SudokuGridView = SudokuGridView