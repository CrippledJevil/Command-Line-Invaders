extends Area2D
var range = 10;
var dmg = 5;
var atkspd = 20;
var chmod = false;
var locked = false;
var enemies;
var closest;
var rotate;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enemies = self.get_overlapping_bodies()
	if enemies.is_empty():
		pass
	var closestDist = 9999999;
	for x in enemies:
		if(x.distance_to(self.position)<closestDist):
			closest = x;
	fire(closest)
	pass
	
func fire(e: Node2D):
	var C:Vector2 = self.position;
	var B:Vector2 = Vector2(0, 1);
	var A = e.position-C;
	var c = sqrt(abs(pow(A.x-B.x, 2)+pow(A.y-B.y, 2)));
	var b = sqrt(abs(pow(A.x-C.x, 2)+pow(C.y-A.y, 2)));
	var a = sqrt(abs(pow(C.x-B.x, 2)+pow(C.y-B.y, 2)));
	var d = acos((pow(a, 2)+pow(b, 2)-pow(c, 2))/2*a*b)
	if (e.position.x < c.x):
		d = 360- d
	rotate = floor(d/45);
	closest.damage(dmg);
	pass