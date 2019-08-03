with (obj_player) {
	//Get inputs (1 = pressed, 0 = not pressed)
	key_right = keyboard_check(ord("D"));
	key_left = keyboard_check(ord("A"));
	key_jump = keyboard_check(vk_space) || keyboard_check(ord("W"));
	throw = mouse_check_button_pressed(mb_right);

	if (mouse_x > x) current_dir = dir.right;
	else current_dir = dir.left;

	if (key_right) {
		hspd = run_speed;
		current_dir = dir.right;
	}
	if (key_left) { 
		hspd = -run_speed;
		current_dir = dir.left;
	}
	
	image_xscale = current_dir == dir.right ? 1 : -1;

	if (!key_right && !key_left) hspd = 0;

	var moving_right = sign(hspd);
	if (place_meeting(x + hspd, y, obj_wall)) {
	    while (!place_meeting(x + moving_right, y, obj_wall)) x += moving_right;
	    hspd = 0;
	}
	x += hspd;

	if (place_meeting(x, y + 1, obj_wall) && key_jump) vspd = jump_speed; 
	vspd += grav;

	
	var moving_down = sign(vspd);
	if (place_meeting(x, y + vspd, obj_wall)) {
	    while (!place_meeting(x, y + moving_down, obj_wall)) y += moving_down;
	    vspd = 0;
	}

	y += floor(vspd);
	
	if (throw) {
		var item = obj_throwable;
		var nothing = false;
		switch (current_item) {
			case item_type.boots:
				item = obj_jump_boots;
		        break;
			case item_type.sword:
				item = obj_sword;
				break;
			case item_type.hammer:
				item = obj_hammer;
				break;
			case item_type.gun:
				item = obj_gun;
				break;
			default:
				nothing = true;
				break;
		}	
		if (!nothing) {
			current_item = item_type.none;
			
			var thrown_item = instance_create_depth(x, y, depth, item);
			thrown_item.thrown = true;
		}
	}
}