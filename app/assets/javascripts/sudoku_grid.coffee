class SudokuGrid
  constructor: ->
    # Initialize the Grid State
    @rows = []
    for i in [0..8]
      @rows[i] = []
      for j in [0..8]
        @rows[i][j] = 0

    # Initlaize Grid Lookup Table
    @G1 = [[0..2], [0..2]]
    @G2 = [[0..2], [3..5]]
    @G3 = [[0..2], [6..8]]
    @G4 = [[3..5], [0..2]]
    @G5 = [[3..5], [3..5]]
    @G6 = [[3..5], [6..8]]
    @G7 = [[6..8], [0..2]]
    @G8 = [[6..8], [3..5]]
    @G9 = [[6..8], [6..8]]
    @subgrids = [
      [@G1, @G1, @G1, @G2, @G2, @G2, @G3, @G3, @G3],
      [@G1, @G1, @G1, @G2, @G2, @G2, @G3, @G3, @G3],
      [@G1, @G1, @G1, @G2, @G2, @G2, @G3, @G3, @G3],
      [@G4, @G4, @G4, @G5, @G5, @G5, @G6, @G6, @G6],
      [@G4, @G4, @G4, @G5, @G5, @G5, @G6, @G6, @G6],
      [@G4, @G4, @G4, @G5, @G5, @G5, @G6, @G6, @G6],
      [@G7, @G7, @G7, @G8, @G8, @G8, @G9, @G9, @G9],
      [@G7, @G7, @G7, @G8, @G8, @G8, @G9, @G9, @G9],
      [@G7, @G7, @G7, @G8, @G8, @G8, @G9, @G9, @G9]]

  getMove: (row, col) ->
    @rows[row][col]

  makeMove: (row, col, value) ->
    @rows[row][col] = value

  clear: ->
    for i in [0..8]
      for j in [0..8]
        this.makeMove(i, j, 0)

  copy: ->
    new_grid = new SudokuGrid()
    for i in [0..8]
      for j in [0..8]
        new_grid.makeMove(i, j, this.getMove(i, j))
    new_grid

  possibleMoves: (row, col) ->
    choices = []
    for i in [0..9]
      choices[i] = true
    # Check Row
    for val in @rows[row]
      choices[val] = false
    # Check Column
    for row_val in @rows
      choices[row_val[col]] = false
    # Check Subgrid
    subgrid = @subgrids[row][col]
    for i in subgrid[0]
      for j in subgrid[1]
        choices[@rows[i][j]] = false
    # Create array os possible moves from remaining choices
    possible = []
    for i in [1..9]
      if choices[i]
        possible.push i
    possible

# Put in Global Namespace
window.SudokuGrid = SudokuGrid