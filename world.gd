extends Node2D

const SERVER_PORT = 4242
const SERVER_IP = "localhost"

const PlayerScene = preload("res://player.tscn")
const BallScene = preload("res://ball.tscn")

@rpc(any_peer, call_local) 
func foo(bar):
	print("[server:%s][%s]: %s" % [multiplayer.is_server(), multiplayer.get_unique_id(), bar])

@rpc(any_peer, call_local) 
func ball(player_id: int):
	#if not multiplayer.is_server():
	#	return
	var player = $Spawn.get_node(str(player_id))
	if not player:
		print("[server:%s][%s]: %s" % [multiplayer.is_server(), multiplayer.get_unique_id(), "no player found"])
		return
	var ball = BallScene.instantiate()
	ball.position = player.position + Vector2(50, 50)
	$Spawn.add_child(ball)
	# $MultiplayerSpawner.spawn(ball)
	pass

func start_server():
	var peer = ENetMultiplayerPeer.new()
	multiplayer.peer_connected.connect(self.create_player)    
	multiplayer.peer_disconnected.connect(self.destroy_player)
	peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	create_player(1)

func start_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = peer

func toggle_ui():
	$HostJoinControls.hide()
	$RpcControls.show()

func _on_HostButton_pressed():
	toggle_ui()
	start_server()

func _on_JoinButton_pressed():
	toggle_ui()
	start_client()

func player_instance(id: int) -> Player:
	var player = PlayerScene.instantiate()
	player.name = str(id)
	return player

func create_player(id: int):
	$Spawn.add_child(player_instance(id))

func destroy_player(id: int):
	$Spawn.get_node(str(id)).queue_free()

func _on_Button_pressed():
	#rpc("foo", Time.get_ticks_msec())
	#rpc("ball", multiplayer.get_unique_id())
	ball(multiplayer.get_unique_id())
	
