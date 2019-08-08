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

	"PlayerTableEnter"
	When player enters a table.

	"PlayerTableExit"
	When player exits a table.

	"RoundStarted"
	When round starts.

	"RoundEnded"
	When round ends.

Server Hooks
	"RoundStarted"
	When round starts.

	"RoundEnded"
	When round ends.

Network Strings
	Server to Client
		"OpenLobby"
		Opens the lobby on the player.

		"closeLobby"
		Closes the lobby on the player.

		"UpdateTableView"
		Tells the client to switch to table cam mode.

		"FadeInMusic"
		Originally for playing lobby music on the player. Deprecated, remove.

		"PlayerTableCheckGUIEnable"
		When both players enter table, and the GUI appears.

		"AnnounceWinnerOfMatch"
		Announces winner of table match.

		"UpdatePlayerVar"
		Updates player var.

		"RRPS_InitializeVars"
		Duh.

		"RRPS_VarDisconnect"
		Clears player vars when disconnect.

		"SendLeaderboardInfo"
		Duh.

		"PrivateMessage"
		Duh.

		"UpdateRoundCompoundTimes"
		I hate explaining these.

		"PlayerTableUpdate"
		When player wins at a table.

		"PlayerTableStatusUpdate"
		Called when player enters table.

		"TableSetPhase"
		Called when table enters set phase.

	Client to Server
		"StartGame"
		Admin button to start the round.

		"KEY_USE"
		Called when player presses the E key. Only used for inventory drop.

		"ZawaPlay"
		Plays a zawa sound on the clients position.

		"UpdateRoundStatus"
		Updates the round status.

		"database"
		Deprecated, remove.

		"InventoryDrop"
		When player drops item.

		"RemovePlayer"
		Called to remove player from gametable player table.

		"ArePlayersReady"
		Verifies if both players at table are ready to play.

		"PlayerReady"
		When player readies up in lobby.

		"BuyoutPlayer"
		Buys out a player.

		"AnnounceVictory"
		Announces when player is victorious.
Global Vars
	Client
		"CompoundTimer"
		Compound time rate.

		"RoundTimer"
		Round time.