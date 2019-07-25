player Network Vars

Bools
	"TableView"
	True if player has used table, false elsewise.

	"Defeated"
	True if player has lost.

	"Victorious"
	True if player has won. (>= 3 stars, no cards)

	"rps_ready"
	Only used in Lobby. True when player clicks ready button.

	"PlayingTable"
	True if player is in table that is currently in a match.

Ints
	"TableWins"
	Tracks how many times a player has won at a table.

	"Luck"
	Value affected by player winning or losing at tables. Affects jukebox song selection.

Entities
	"TableUsing"
	The table the player is currently using.

Client Hooks
	"KEY_USE"
	When player has pressed the E button. Kinda useless.

	"PlayerTableWin"
	When player has won at a table.

	"PlayerTableLoss"
	When player has lost at a table.

	"RoundStarted"
	When round starts.

	"RoundEnded"
	When round ends.

Server Hooks
	"RoundStarted"
	When round starts.

	"RoundEnded"
	When round ends.