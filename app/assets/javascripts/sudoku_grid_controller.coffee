class SudokuGridController
  constructor: (sudoku_grid) ->
    @sudoku_grid = sudoku_grid
    @backtracking_solver = null
    this.initializeEventHandlers()

  initializeEventHandlers: ->
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

  handleSolveButton: ->
    $('#solve_modal').modal({keyboard: false, show: true})
    $('#results_table').html('<tr><th>Solver</th><th>Results</th><th>Actions</th></tr>')
    
    # Solve Puzzle / Show Results
    setTimeout(this.solveWithBacktracking, 100)

  solveWithBacktracking: =>
    @backtracking_solver = new window.BacktrackingSolver(@sudoku_grid.copy())
    start = new Date()
    @backtracking_solver.solve()
    stop = new Date()
    backtracking_results_button = '<button id="show_backtracking" class="btn btn-large">Show Answer</button>'
    this.appendSolverResults('BacktrackingSolver', "#{(stop-start)/1000} seconds", backtracking_results_button)
    
    $('#solve_modal').modal('hide')

  appendSolverResults: (name, results, button) ->
    solver_name = 'BacktrackingSolver'
    solver_results = 'true'
    $('#results_table').append("<tr><td>#{name}</td><td>#{results}</td><td>#{button}</td></tr>")

  handleClearAnswerButton: ->
    this.displayGrid(@sudoku_grid)

  handleClearPuzzleButton: ->
    @sudoku_grid.clear()
    this.displayGrid(@sudoku_grid)

  handleShowBacktrackingResults: ->
    if @backtracking_solver
      this.displayGrid(@backtracking_solver.getGrid())

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

# On Ready
$ ->
  window.sudoku_grid_controller = new SudokuGridController(new window.SudokuGrid())