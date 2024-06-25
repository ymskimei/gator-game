extends Spatial

static func create_packed(n: Node) -> PackedScene:
	set_ow(n, n)
	var packed = PackedScene.new()
	packed.pack(n)
	return packed

static func set_ow(n: Node, ow: Node) -> void:
	for child in n.get_children():
		child.owner = ow
		set_ow(child, ow)
