class BacktrackingSolver
  
  solve: (sudoku_grid) ->
    @sudoku_grid = sudoku_grid
    @guesses = 0
    start = new Date()
    try
      this.advance_guess(0, 0)
    catch error
      console.log error
    stop = new Date()
    "Found solution in #{@guesses} guesses, #{(stop-start)/1000} seconds"

  advance_guess: (row, col) ->
    if row == 9
      throw "Finished Solution"
    else if col == 9
      this.advance_guess(row+1, 0) # Advance Row
    else
      if @sudoku_grid.getMove(row, col) != 0
        this.advance_guess(row, col+1) # Skip Initial State Columns
      else
        possible_moves = @sudoku_grid.possibleMoves(row, col)
        _.each possible_moves, (move) =>
          @sudoku_grid.makeMove(row, col, move)
          @guesses = @guesses + 1
          this.advance_guess(row, col+1)
        # No Move
        @sudoku_grid.makeMove(row, col, 0)


window.BacktrackingSolver = BacktrackingSolver