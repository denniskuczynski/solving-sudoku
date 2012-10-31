class ResultsController
  constructor: (sudoku_grid_view) ->
    @sudoku_grid_view = sudoku_grid_view
    @backtracking_solver = new window.BacktrackingSolver()
    @backtracking_most_constrained_solver = new window.BacktrackingMostConstrainedSolver()
    this.initializeEventHandlers()

  initializeEventHandlers: ->
    if $('#results_table').length
      $('#results_table').on 'click', '#show_backtracking', (event) =>
        event.preventDefault()
        this.handleShowBacktrackingResults()
      $('#results_table').on 'click', '#show_backtracking_most_constrained', (event) =>
        event.preventDefault()
        this.handleShowBacktrackingMostConstrainedResults()

  solve: (sudoku_grid) ->
    $('#solve_modal').modal({keyboard: false, show: true})
    $('#results_table').html('<tr><th>Solver</th><th>Results</th><th>Actions</th></tr>')
    # Solve Puzzle with Backtracking
    @backtracking_solver_grid = sudoku_grid.copy()
    @backtracking_most_constrained_solver_grid = sudoku_grid.copy()
    setTimeout(this.solveWithBacktracking, 1000)

  solveWithBacktracking: =>
    results = @backtracking_solver.solve(@backtracking_solver_grid)
    backtracking_results_button = '<button id="show_backtracking" class="btn btn-large">Show Answer</button>'
    this.appendSolverResults('Backtracking (First Square)', results, backtracking_results_button)
    # Solve Puzzle with Backtracking (Most Constrained)
    setTimeout(this.solveWithBacktrackingMostConstrained, 1000)

  solveWithBacktrackingMostConstrained: =>
    results = @backtracking_most_constrained_solver.solve(@backtracking_most_constrained_solver_grid)
    backtracking_results_button = '<button id="show_backtracking_most_constrained" class="btn btn-large">Show Answer</button>'
    this.appendSolverResults('Backtracking (Most Constrained Square)', results, backtracking_results_button)
    # Show Results
    $('#solve_modal').modal('hide')

  appendSolverResults: (name, results, button) ->
    $('#results_table').append("<tr><td>#{name}</td><td>#{results}</td><td>#{button}</td></tr>")

  handleShowBacktrackingResults: ->
    if @backtracking_solver_grid
      @sudoku_grid_view.displayGrid(@backtracking_solver_grid)

  handleShowBacktrackingMostConstrainedResults: ->
    if @backtracking_most_constrained_solver_grid
      @sudoku_grid_view.displayGrid(@backtracking_most_constrained_solver_grid)

window.ResultsController = ResultsController