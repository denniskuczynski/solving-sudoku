class BacktrackingSolver
  constructor: (sudoku_grid) ->
    @sudoku_grid = sudoku_grid

  getGrid: ->
    @sudoku_grid

  solve: ->
    try
      this.advance_guess(0, 0)
    catch error
      console.log error
    true

  advance_guess: (row, col) ->
    #console.log("Solve #{row}, #{col}")
    if row == 9
      throw "Finished Solution"
    else if col == 9
      this.advance_guess(row+1, 0) # Advance Row
    else
      if @sudoku_grid.getMove(row, col) != 0
        this.advance_guess(row, col+1) # Move present
      else
        possible_moves = @sudoku_grid.possibleMoves(row, col)
        _.each possible_moves, (move) =>
            #console.log "Trying #{move} at #{row}, #{col}"
            @sudoku_grid.makeMove(row, col, move)
            this.advance_guess(row, col+1)
        # No Move
        #console.log "No move at #{row}, #{col}"
        @sudoku_grid.makeMove(row, col, 0)


window.BacktrackingSolver = BacktrackingSolver