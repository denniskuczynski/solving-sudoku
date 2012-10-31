class SudokuGridController
  constructor: (sudoku_grid) ->
    @sudoku_grid = sudoku_grid
    @backtracking_solver = new window.BacktrackingSolver()
    @backtracking_most_constrained_solver = new window.BacktrackingMostConstrainedSolver()
    this.initializeEventHandlers()

  initializeEventHandlers: ->
    if $('#example_easy').length
      $('#example_easy').click (event) =>
        event.preventDefault()
        this.handleExampleEasy()
    if $('#example_hard').length
      $('#example_hard').click (event) =>
        event.preventDefault()
        this.handleExampleHard()
    if $('#solve_button').length
      $('#solve_button').click (event) =>
        event.preventDefault()
        this.handleSolveButton()
    if $('#clear_answer_button').length
      $('#clear_answer_button').click (event) =>
        event.preventDefault()
        this.handleClearAnswerButton()
    if $('#clear_puzzle_button').length
      $('#clear_puzzle_button').click (event) =>
        event.preventDefault()
        this.handleClearPuzzleButton()
    if $('#sudoku_grid').length
      $('#sudoku_grid').on 'click', '.sudoku_box', (event) =>
        event.preventDefault()
        this.handleGridBox(event.currentTarget)
    if $('#results_table').length
      $('#results_table').on 'click', '#show_backtracking', (event) =>
        event.preventDefault()
        this.handleShowBacktrackingResults()
      $('#results_table').on 'click', '#show_backtracking_most_constrained', (event) =>
        event.preventDefault()
        this.handleShowBacktrackingMostConstrainedResults()

  handleSolveButton: ->
    $('#solve_modal').modal({keyboard: false, show: true})
    $('#results_table').html('<tr><th>Solver</th><th>Results</th><th>Actions</th></tr>')
    # Solve Puzzle with Backtracking
    setTimeout(this.solveWithBacktracking, 1000)

  solveWithBacktracking: =>
    @backtracking_solver_grid = @sudoku_grid.copy()
    results = @backtracking_solver.solve(@backtracking_solver_grid)
    backtracking_results_button = '<button id="show_backtracking" class="btn btn-large">Show Answer</button>'
    this.appendSolverResults('Backtracking (First Square)', results, backtracking_results_button)
    # Solve Puzzle with Backtracking (Most Constrained)
    setTimeout(this.solveWithBacktrackingMostConstrained, 1000)

  solveWithBacktrackingMostConstrained: =>
    @backtracking_most_constrained_solver_grid = @sudoku_grid.copy()
    results = @backtracking_most_constrained_solver.solve(@backtracking_most_constrained_solver_grid)
    backtracking_results_button = '<button id="show_backtracking_most_constrained" class="btn btn-large">Show Answer</button>'
    this.appendSolverResults('Backtracking (Most Constrained Square)', results, backtracking_results_button)
    # Show Results
    $('#solve_modal').modal('hide')

  appendSolverResults: (name, results, button) ->
    $('#results_table').append("<tr><td>#{name}</td><td>#{results}</td><td>#{button}</td></tr>")

  handleClearAnswerButton: ->
    this.displayGrid(@sudoku_grid)

  handleClearPuzzleButton: ->
    @sudoku_grid.clear()
    this.displayGrid(@sudoku_grid)

  handleShowBacktrackingResults: ->
    if @backtracking_solver_grid
      this.displayGrid(@backtracking_solver_grid)

  handleShowBacktrackingMostConstrainedResults: ->
    if @backtracking_most_constrained_solver_grid
      this.displayGrid(@backtracking_most_constrained_solver_grid)

  handleGridBox: (box_div) ->
    box_ids = box_div.id.split('_')
    row = box_ids[1]
    col = box_ids[2]
    @sudoku_grid.makeMove(row, col, 0)
    possible_moves = @sudoku_grid.possibleMoves(row, col)
    if possible_moves.length == 0
      box_div.innerHTML = ''
    else
      # Try to find the current move in the set of all possible moves for the box
      # If not found, return the first input
      # If the last element, reset the box
      # Otherwise, return the next move
      current_index = _.indexOf(possible_moves, this.getCurrentMove(box_div), true)
      if (current_index == -1)
        box_div.innerHTML = possible_moves[0]
        @sudoku_grid.makeMove(row, col, possible_moves[0])
      else if (current_index == possible_moves.length-1)
        box_div.innerHTML = ''
        @sudoku_grid.makeMove(row, col, 0)
      else
        box_div.innerHTML = possible_moves[current_index+1]
        @sudoku_grid.makeMove(row, col, possible_moves[current_index+1])

  getCurrentMove: (box_div) ->
    current_move = box_div.innerHTML
    current_move = '0' if current_move == undefined
    parseInt(current_move)

  displayGrid: (sudoku_grid) ->
    for i in [0..8]
      for j in [0..8]
        if sudoku_grid.getMove(i, j) == 0
          $("#box_#{i}_#{j}").text('')
        else
          $("#box_#{i}_#{j}").text(sudoku_grid.getMove(i, j))

  handleExampleEasy: ->
    @sudoku_grid.clear()
    @sudoku_grid.makeMove(0, 2, 8)
    @sudoku_grid.makeMove(0, 3, 3)
    @sudoku_grid.makeMove(0, 6, 4)
    @sudoku_grid.makeMove(0, 8, 2)
    @sudoku_grid.makeMove(1, 3, 4)
    @sudoku_grid.makeMove(1, 6, 3)
    @sudoku_grid.makeMove(2, 0, 2)
    @sudoku_grid.makeMove(2, 3, 6)
    @sudoku_grid.makeMove(2, 6, 5)
    @sudoku_grid.makeMove(2, 7, 9)
    @sudoku_grid.makeMove(2, 8, 1)
    @sudoku_grid.makeMove(3, 0, 6)
    @sudoku_grid.makeMove(3, 1, 1)
    @sudoku_grid.makeMove(3, 2, 9)
    @sudoku_grid.makeMove(3, 5, 4)
    @sudoku_grid.makeMove(4, 4, 9)
    @sudoku_grid.makeMove(5, 3, 2)
    @sudoku_grid.makeMove(5, 6, 9)
    @sudoku_grid.makeMove(5, 7, 1)
    @sudoku_grid.makeMove(5, 8, 5)
    @sudoku_grid.makeMove(6, 0, 1)
    @sudoku_grid.makeMove(6, 1, 4)
    @sudoku_grid.makeMove(6, 2, 3)
    @sudoku_grid.makeMove(6, 5, 7)
    @sudoku_grid.makeMove(6, 8, 9)
    @sudoku_grid.makeMove(7, 2, 6)
    @sudoku_grid.makeMove(7, 5, 3)
    @sudoku_grid.makeMove(8, 0, 9)
    @sudoku_grid.makeMove(8, 2, 2)
    @sudoku_grid.makeMove(8, 5, 5)
    @sudoku_grid.makeMove(8, 6, 8)
    this.displayGrid(@sudoku_grid)

  handleExampleHard: ->
    @sudoku_grid.clear()
    @sudoku_grid.makeMove(0, 7, 1)
    @sudoku_grid.makeMove(0, 8, 2)
    @sudoku_grid.makeMove(1, 4, 3)
    @sudoku_grid.makeMove(1, 5, 5)
    @sudoku_grid.makeMove(2, 3, 6)
    @sudoku_grid.makeMove(2, 7, 7)
    @sudoku_grid.makeMove(3, 0, 7)
    @sudoku_grid.makeMove(3, 6, 3)
    @sudoku_grid.makeMove(4, 3, 4)
    @sudoku_grid.makeMove(4, 6, 8)
    @sudoku_grid.makeMove(5, 0, 1)
    @sudoku_grid.makeMove(6, 3, 1)
    @sudoku_grid.makeMove(6, 4, 2)
    @sudoku_grid.makeMove(7, 1, 8)
    @sudoku_grid.makeMove(7, 7, 4)
    @sudoku_grid.makeMove(8, 1, 5)
    @sudoku_grid.makeMove(8, 6, 6)
    this.displayGrid(@sudoku_grid)

# On Ready
$ ->
  window.sudoku_grid_controller = new SudokuGridController(new window.SudokuGrid())
