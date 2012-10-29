class SudokuGrid
	constructor: ->
		# Initialize the Grid State
		@subgrids = []
		for i in [0..8]
			@subgrids[i] = []
			for j in [0..8]
				@subgrids[i][j] = 0

	possibleMoves: (subgrid, box) ->
		return []

    # Find current_move string in integer array of possible_moves
	find_current_move: (current_move, possible_moves) ->
	    if (current_move == undefined)
	    	return -1
	    else
	        for i in [0..possible_moves.length-1]
	        	if possible_moves[i] == parseInt(current_move)
	        		return i
	        return -1

# On Ready
$ ->
  window.sudoku_grid = new SudokuGrid()

  if $('#solve_button').length
  	$('#solve_button').click (event) ->
  		event.preventDefault()

  if $('#clear_answer_button').length
  	$('#clear_answer_button').click (event) ->
  		event.preventDefault()

  if $('#clear_puzzle_button').length
  	$('#clear_puzzle_button').click (event) ->
  		event.preventDefault()

  if $('#sudoku_grid').length
    $('#sudoku_grid').on 'click', '.sudoku_box', (event) ->
    	box_ids = this.id.split('_')
    	subgrid = box_ids[1]
    	box = box_ids[2]

    	possible_moves = window.sudoku_grid.possibleMoves(subgrid, box)
    	if possible_moves.length == 0
    		this.innerHTML = ''
    	else
    	    current_index = window.sudoku_grid.find_current_move(this.innerHTML, possible_moves)
    	    if (current_index == -1)
    	    	this.innerHTML = possible_moves[0]
    	    else if (current_index == possible_moves.length-1)
    	    	this.innerHTML = ''
    	    else
    	    	this.innerHTML = possible_moves[current_index+1]
