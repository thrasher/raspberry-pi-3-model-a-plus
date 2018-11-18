// raspberry-pi-3-model-a-plus
// Nov 16, 2018
// author: Jason Thrasher
//
// This is a rough drawing of a Raspberry Pi 3 A+.
// It is suitable for use in 3D printing or case layouts.
//
// part reference
// https://www.raspberrypi.org/products/raspberry-pi-3-model-a-plus/
// dimensions taken from mechanical drawing and Raspbery Pi 3 B+ caliper measurements
// https://www.raspberrypi.org/app/uploads/2018/11/Raspberry_Pi_3A_mechanical-drawing.pdf
//
// Dimensions in millimeters

$fs = 0.1; // mm per facet in cylinder
$fa = 5; // degrees per facet in cylinder
$fn = 100;


BOARD_CORNER_R = 3.5;
BOARD_THICKNESS = 1.15; // 1.15 as measured on Raspberry Pi 3 Model B+
MOUNTING_HOLE_DIA = 0.125 * 25.4; // convert inches to mm
BOARD_W = 65; // 3A+ drawing
BOARD_H = 56; // 3A+ drawing
UNDERSIDE_DEPTH = 2.2; // clearence required by 3B+

module board_2d_positive(RADIUS = 10) {
		circle(r = RADIUS);
		translate([58,0,0])
		circle(r = RADIUS);
		translate([58,49,0])
		circle(r = RADIUS);
		translate([0,49,0])
		circle(r = RADIUS);
}
module board_2d() {
	difference() {
		hull()
		board_2d_positive(BOARD_CORNER_R);
		board_2d_positive(MOUNTING_HOLE_DIA/2);
	}
}

module board() {
	linear_extrude(height = BOARD_THICKNESS)
	board_2d();
}

module  pin_header() {
	// from 3B+ pin header: 5.1 x 50.7 x 10.4-BOARD_THICKNESS
	H = 10.4-BOARD_THICKNESS;
	translate([29, 49, H/2 + BOARD_THICKNESS])
	cube([50.7, 5.1, H ], center = true);
}

module DSI_display_port() {
	// from 3B+ pin header: 22 x 2.5 x 6.9-BOARD_THICKNESS
	// height specified in 3A+ drawing: 5.5
	H = 5.5;

	translate([0, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([0, 28, H/2])
	rotate([0,0,90])
	cube([22, 2.5, H ], center = true);
}

module CSI_camera_port() {
	// from 3B+ pin header: 22.1 x 2.5 x 6.9-BOARD_THICKNESS
	// height specified in 3A+ drawing: 5.5
	H = 5.5;
	translate([ -BOARD_CORNER_R, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([45, 11.5, H/2])
	rotate([0,0,90])
	cube([22.1, 2.5, H ], center = true);
}

module usb_port() {
	// from 3B+ usb: width: 15, depth: 17.25
	W = 15;
	D = 17.25;
	H = 7.1; // height specified in 3A+ drawing: 7.1
	OVERHANG = 2.15; // board USB overhang measured from 3B+: 2.15;

	translate([ -BOARD_CORNER_R, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([65 - D/2 + OVERHANG, 31.45, H/2])
	// rotate([0,0,90])
	cube([D, W, H ], center = true);
}

module audio_port() {
	W = 7;
	D_PORT = 2.5; // round port dia measured from 3B+
	D = 15.5; // overall port depth measured from 3B+
	H = 6; // height specified in 3A+ drawing: 6

	OVERHANG = 2.15; // board USB overhang measured from 3B+: 2.15;

	translate([ -BOARD_CORNER_R + BOARD_W, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([-11.5, (D-D_PORT)/2, H/2])
	rotate([0,0,-90])
	//translate([D/2,0,0])
	union() {
		cube([D - D_PORT, W, H ], center = true);
		translate([D/2,0,0])
		rotate([0,90,0])
		cylinder(d = H, h = D_PORT, center = true);
	}
}

module hdmi_port() {
	// from 3B+ usb: width: 15, depth: 17.25
	W = 15;
	D = 11.7;
	H = 6.5; // height specified in 3A+ drawing: 7.1
	OVERHANG = 1.5; // board USB overhang measured from 3B+: 1.5

	translate([ -BOARD_CORNER_R, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([32, D/2-OVERHANG, H/2])
	rotate([0,0,90])
	cube([D, W, H ], center = true);
}

module mini_usb_port() {
	// from 3B+ usb: width: 15, depth: 17.25
	W = 8;
	D = 5.6;
	H = 4 - BOARD_THICKNESS; // measured from 3B+
	OVERHANG = 1.25; // board USB overhang measured from 3B+

	translate([ -BOARD_CORNER_R, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([10.6, D/2-OVERHANG, H/2])
	rotate([0,0,90])
	cube([D, W, H ], center = true);
}

module _cut_square() {
	hull() {
		translate([-BOARD_CORNER_R,-BOARD_CORNER_R,0])
  	square(BOARD_CORNER_R);
  	circle(r = BOARD_CORNER_R);
		translate([0,-BOARD_CORNER_R,0])
  	square(BOARD_CORNER_R);
		translate([-BOARD_CORNER_R,0,0])
  	square(BOARD_CORNER_R);
  }
}
module mounting_posts() {
		_cut_square();
		translate([58,0,0])
		rotate(90)
		_cut_square();
		translate([58,49,0])
		rotate(180)
		_cut_square();
		translate([0,49,0])
		rotate(270)
		_cut_square();
}
// clearence for solder joints or components on underside of board
module underside_clearence() {
	translate([0,0,-UNDERSIDE_DEPTH])
	linear_extrude(height = UNDERSIDE_DEPTH)
	difference() {
		board_2d();
		mounting_posts();
	}
}

module components() {
	color("grey") pin_header();
	color("grey") DSI_display_port();
	color("grey") CSI_camera_port();
	color("silver") usb_port();
	color("silver") audio_port();
	color("silver") hdmi_port();
	color("silver") mini_usb_port();
}

module 3Aplus() {
	board();
	components();
	color("blue", alpha = 0.2) underside_clearence();
}

INTERIOR_HEIGHT = 12.5;
CASE_WALL_THICKNESS = 1.5;
CASE_PI_CLEARENCE = 0.5; // space btw pi edge and case wall
module case_plain() {
	// mounting posts
	linear_extrude(height = BOARD_THICKNESS)
	board_2d_positive(MOUNTING_HOLE_DIA/2 * 0.9);

	// upper walls
	linear_extrude(height = INTERIOR_HEIGHT)
	difference() {
		hull() board_2d_positive(BOARD_CORNER_R + CASE_WALL_THICKNESS);
		hull() board_2d_positive(BOARD_CORNER_R + CASE_PI_CLEARENCE);
	}

	// through-hole clearence below g10
	translate([0,0,-UNDERSIDE_DEPTH])
	linear_extrude(height = UNDERSIDE_DEPTH)
	difference() {
		hull() board_2d_positive(BOARD_CORNER_R + CASE_WALL_THICKNESS);
		difference() {
			hull() board_2d_positive(BOARD_CORNER_R + 0);
			mounting_posts();
		}
	}

	// floor
	translate([0,0,-UNDERSIDE_DEPTH-CASE_WALL_THICKNESS])
	linear_extrude(height = CASE_WALL_THICKNESS)
	hull() board_2d_positive(BOARD_CORNER_R + CASE_WALL_THICKNESS);
}

module case() {
	difference() {
		case_plain();
		scale([1.1, 1, 1])
		usb_port();
		scale([1, 1, 1])
		audio_port();
		scale([1, 1.1, 1])
		hdmi_port();
		scale([1, 1.1, 1])
		mini_usb_port();
	}
}

// render.py
part = 0;
if (part == 1) {
	3Aplus();
} else if (part == 2) {
	color("blue") case();
} else {
	3Aplus();
	color("blue") case();
}
