class BacktrackingMostConstrainedSolver
  constructor: (sudoku_grid) ->
    @sudoku_grid = sudoku_grid

  getGrid: ->
    @sudoku_grid

  solve: ->
    try
      this.advance_guess()
    catch error
      console.log error
    true

  advance_guess: ->
    open_square_list = this.open_squares()
    #console.log "Open Squares: #{open_square_list.length}"
    if open_square_list.length == 0
      throw "Finished Solution"
    else
      most_constrained_list = this.sort_most_constrained(open_square_list)
      square = most_constrained_list[0] # Select Most Constrained Square
      row = square[0]
      col = square[1]
      possible_moves = @sudoku_grid.possibleMoves(row, col)
      _.each possible_moves, (move) =>
        #console.log "Trying #{move} at #{row}, #{col}"
        @sudoku_grid.makeMove(row, col, move)
        this.advance_guess()
      # No Move
      #console.log "No move at #{row}, #{col}"
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