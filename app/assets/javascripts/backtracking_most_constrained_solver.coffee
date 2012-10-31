class BacktrackingMostConstrainedSolver

  solve: (sudoku_grid) ->
    @sudoku_grid = sudoku_grid
    @guesses = 0
    start = new Date()
    try
      this.advance_guess()
    catch error
      console.log error
    stop = new Date()
    "Found solution in #{@guesses} guesses, #{(stop-start)/1000} seconds"

  advance_guess: ->
    open_square_list = this.open_squares()
    if open_square_list.length == 0
      throw "Finished Solution"
    else
      most_constrained_list = this.sort_most_constrained(open_square_list)
      most_constrained_square = most_constrained_list[0]
      row = most_constrained_square[0]
      col = most_constrained_square[1]
      possible_moves = @sudoku_grid.possibleMoves(row, col)
      _.each possible_moves, (move) =>
        @sudoku_grid.makeMove(row, col, move)
        @guesses = @guesses + 1
        this.advance_guess()
      # No Move
      @sudoku_grid.makeMove(row, col, 0)

  open_squares: ->
    open_square_list = []
    for i in [0..8]
      for j in [0..8]
        if @sudoku_grid.getMove(i, j) == 0
          open_square_list.push([i,j])
    open_square_list

  sort_most_constrained: (square_list) ->
    _.sortBy square_list, (square) =>
      row = square[0]
      col = square[1]
      @sudoku_grid.possibleMoves(row, col).length

window.BacktrackingMostConstrainedSolver = BacktrackingMostConstrainedSolver