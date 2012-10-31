class SudokuGridController
  constructor: (sudoku_grid) ->
    @sudoku_grid = sudoku_grid
    @examplePuzzles = new window.ExamplePuzzles()
    @sudoku_grid_view = new window.SudokuGridView()
    @resultsController = new window.ResultsController(@sudoku_grid_view)
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

  handleExampleEasy: ->
    @examplePuzzles.setExampleEasy(@sudoku_grid)
    @sudoku_grid_view.displayGrid(@sudoku_grid)

  handleExampleHard: ->
    @examplePuzzles.setExampleHard(@sudoku_grid)
    @sudoku_grid_view.displayGrid(@sudoku_grid)

  handleSolveButton: ->
    @resultsController.solve(@sudoku_grid)

  handleClearAnswerButton: ->
    @sudoku_grid_view.displayGrid(@sudoku_grid)

  handleClearPuzzleButton: ->
    @sudoku_grid.clear()
    @sudoku_grid_view.displayGrid(@sudoku_grid)

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

# On Ready
$ ->
  window.sudoku_grid_controller = new SudokuGridController(new window.SudokuGrid())
