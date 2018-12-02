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
HOLE_W = 58;
HOLE_H = 49;
UNDERSIDE_DEPTH = 3; // clearence required by 3B+: 2.2
WARP_OFFSET = 0.15;

// layout children relative to each mounting hole
module mounting_layout() {
		children();
		translate([HOLE_W, 0, 0])
		rotate(90)
		children();
		translate([HOLE_W, HOLE_H, 0])
		rotate(180)
		children();
		translate([0, HOLE_H, 0])
		rotate(270)
		children();
}

module board_2d_positive(RADIUS = 10) {
		mounting_layout() circle(r = RADIUS);
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
	translate([29, HOLE_H, H/2 + BOARD_THICKNESS])
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

module usb_port(DO_CUTOUT = false) {
	// from 3B+ usb: width: 15, depth: 17.25
	W = 15;
	D = 17.25;
	H = 7.1; // height specified in 3A+ drawing: 7.1
	OVERHANG = 2.15; // board USB overhang measured from 3B+: 2.15;

	translate([ -BOARD_CORNER_R, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([65 - D/2 + OVERHANG, 31.45, H/2])
	union() {
		cube([D, W, H ], center = true);

		// properly oriented case cutout
		if (DO_CUTOUT) {
			CUTOUT_MARGIN = 0.5;
			port_cutout(W + CUTOUT_MARGIN*2, H + CUTOUT_MARGIN*2, CUTOUT_MARGIN);
		}
	}
}

module audio_port(DO_CUTOUT = false) {
	W = 7;
	D_PORT = 2.5; // round port dia measured from 3B+
	D = 15.5; // overall port depth measured from 3B+
	H = 6; // diameter of port measured from 3B+

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
		// case cutout
		if (DO_CUTOUT) {
			// port_cutout(0, 0, D_PORT/2 + 0.3);
			CUTOUT_MARGIN = 0.5 + H/2;
			port_cutout(CUTOUT_MARGIN*2, CUTOUT_MARGIN*2, CUTOUT_MARGIN);
		}
	}
}

module hdmi_port(DO_CUTOUT = false) {
	// from 3B+ usb: width: 15, depth: 17.25
	W = 15;
	D = 11.7;
	H = 6.5; // height specified in 3A+ drawing: 7.1
	OVERHANG = 1.5; // board USB overhang measured from 3B+: 1.5

	translate([ -BOARD_CORNER_R, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([32, D/2-OVERHANG, H/2])
	rotate([0,0,-90])
	union() {
		cube([D, W, H ], center = true);
		// properly oriented case cutout
		if (DO_CUTOUT) {
			CUTOUT_MARGIN = 0.5;
			port_cutout(W + CUTOUT_MARGIN*2, H + CUTOUT_MARGIN*2, CUTOUT_MARGIN);
		}
	}
}

module mini_usb_port(DO_CUTOUT = false) {
	// from 3B+ usb: width: 15, depth: 17.25
	W = 8;
	D = 5.6;
	H = 4 - BOARD_THICKNESS; // measured from 3B+
	OVERHANG = 1.25; // board USB overhang measured from 3B+

	translate([ -BOARD_CORNER_R, -BOARD_CORNER_R, BOARD_THICKNESS])
	translate([10.6, D/2-OVERHANG, H/2])
	rotate([0,0,-90])
	union() {
		cube([D, W, H ], center = true);
		// properly oriented case cutout
		if (DO_CUTOUT) {
			CUTOUT_MARGIN = 0.5;
			port_cutout(W + CUTOUT_MARGIN*2, H + CUTOUT_MARGIN*2, CUTOUT_MARGIN);
		}
	}
}

module sdcard_slot(DO_CUTOUT = false) {
	// note: inserted card sticks out 2.5mm from edge of G10
	// from 3B+ usb: width: 15, depth: 17.25
	W = 12;
	D = 11.5;
	H = 1.5 + 0.5; // measured from 3B+ as 1.5, but card adds 0.5
	OVERHANG = -1.5; // board USB overhang measured from 3B+

	translate([ -BOARD_CORNER_R, -BOARD_CORNER_R, -H/2])
	translate([D/2 - OVERHANG, BOARD_H/2, 0])
	rotate([0,0,180])
	union() {
		cube([D, W, H], center = true);

		// properly oriented case cutout
		if (DO_CUTOUT) {
			CUTOUT_MARGIN = 1;
			port_cutout(W + CUTOUT_MARGIN*2, H + CUTOUT_MARGIN*2, CUTOUT_MARGIN);
		}
	}
}

module port_cutout(W, H, CUT_RADIUS = 0.2) {
	// CUT_RADIUS = 0.2;
	CUT_WIDTH = W - CUT_RADIUS*2;
	CUT_HEIGHT = H - CUT_RADIUS*2;
	CUT_DEPTH = 30;

	translate([CUT_DEPTH/2,0,0])
	rotate([0,90,0])
	hull() {
		CW = CUT_WIDTH/2;
		CH = CUT_HEIGHT/2;

		translate([-CH,-CW,0])
		cylinder(r = CUT_RADIUS, h = CUT_DEPTH, center = true);
		translate([CH,CW,0])
		cylinder(r = CUT_RADIUS, h = CUT_DEPTH, center = true);
		translate([-CH,CW,0])
		cylinder(r = CUT_RADIUS, h = CUT_DEPTH, center = true);
		translate([CH,-CW,0])
		cylinder(r = CUT_RADIUS, h = CUT_DEPTH, center = true);
	}
}

module mounting_post(INTERIOR_EDGE = BOARD_CORNER_R + CASE_PI_CLEARENCE) {
	// difference() {
		hull() {
			QUARTER = BOARD_CORNER_R * 0.6;
	  	circle(r = QUARTER);

			// translate([-BOARD_CORNER_R,-BOARD_CORNER_R,0])
	  	// square(QUARTER);

			translate([0,-INTERIOR_EDGE,0])
	  	square([QUARTER, INTERIOR_EDGE]);

			translate([-INTERIOR_EDGE,0,0])
	  	square([INTERIOR_EDGE, QUARTER]);

	  	// wall side quarter curve
			difference() {
			  circle(r = INTERIOR_EDGE);
			  square(INTERIOR_EDGE);
				translate([0,-INTERIOR_EDGE,0])
			  square(INTERIOR_EDGE);
				translate([-INTERIOR_EDGE,0,0])
			  square(INTERIOR_EDGE);
			}
	  }
	  // hole to screw into
	 //  circle(d = MOUNTING_HOLE_DIA*.75);
  // }

}

module mounting_posts(INTERIOR_EDGE = BOARD_CORNER_R + CASE_PI_CLEARENCE) {
	mounting_layout() mounting_post(INTERIOR_EDGE);
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

module components(DO_CUTOUT = false) {
	color("grey") pin_header();
	color("grey") DSI_display_port();
	color("grey") CSI_camera_port();
	color("silver") usb_port(DO_CUTOUT);
	color("silver") audio_port(DO_CUTOUT);
	color("silver") hdmi_port(DO_CUTOUT);
	color("silver") mini_usb_port(DO_CUTOUT);
	color("red") sdcard_slot(DO_CUTOUT);
}

module 3Aplus() {
	board();
	components();
	color("blue", alpha = 0.2) underside_clearence();
}

LID_DEPTH = 8.35;
INTERIOR_HEIGHT = 12.5 - LID_DEPTH;
CASE_WALL_THICKNESS = 2.5;
CASE_PI_CLEARENCE = 1.0; // space btw pi edge and case wall
FLOOR_THICKNESS = CASE_WALL_THICKNESS * 2;

module sphere_post() {
	//cylinder(d = MOUNTING_HOLE_DIA * 0.75, h = BOARD_THICKNESS);
	//translate([0,0,BOARD_THICKNESS])
	sphere(d = MOUNTING_HOLE_DIA * .75);
}

module lid() {
	// upper walls
	difference() {
		translate([0,0,INTERIOR_HEIGHT])
		linear_extrude(height = LID_DEPTH, convexity = 2)
		difference() {
			hull() board_2d_positive(BOARD_CORNER_R + CASE_WALL_THICKNESS);
			hull() board_2d_positive(BOARD_CORNER_R + CASE_PI_CLEARENCE);
		}

		// offset to accomodate weird warpage
		translate([0, 0, WARP_OFFSET])
		components(DO_CUTOUT = true);
	}

	// closed top cover
	translate([0,0,INTERIOR_HEIGHT + LID_DEPTH]) {
	hull() {
	linear_extrude(height = 0.1)
	board_2d_positive(BOARD_CORNER_R + CASE_WALL_THICKNESS);
	translate([0,0,FLOOR_THICKNESS/2])
	// hull()
	mounting_layout()
	rotate([0,0,180])
  rotate_extrude(angle = 90, convexity = 100)
  translate([BOARD_CORNER_R + CASE_WALL_THICKNESS - FLOOR_THICKNESS/2, 0, 0])
	circle(d = FLOOR_THICKNESS);
	}
	}

	// locking posts
	translate([0,0,INTERIOR_HEIGHT])
	linear_extrude(height = LID_DEPTH, convexity = 2)
	mounting_posts(BOARD_CORNER_R + CASE_PI_CLEARENCE);
	translate([0,0,BOARD_THICKNESS + WARP_OFFSET])
	linear_extrude(height = INTERIOR_HEIGHT - BOARD_THICKNESS - WARP_OFFSET, convexity = 2)
	mounting_posts(BOARD_CORNER_R + CASE_PI_CLEARENCE - 0.1);

}

// case_plain();
module case_plain() {
	// upper walls
	linear_extrude(height = INTERIOR_HEIGHT, convexity = 2)
	difference() {
		hull() board_2d_positive(BOARD_CORNER_R + CASE_WALL_THICKNESS);
		hull() board_2d_positive(BOARD_CORNER_R + CASE_PI_CLEARENCE);
	}

	// through-hole clearence below g10
	translate([0,0,-UNDERSIDE_DEPTH])
	linear_extrude(height = UNDERSIDE_DEPTH, convexity = 2)
	union() {
		difference() {
			hull() board_2d_positive(BOARD_CORNER_R + CASE_WALL_THICKNESS);
			hull() board_2d_positive(BOARD_CORNER_R + CASE_PI_CLEARENCE);
		}
		mounting_posts();
	}

	// floor
	translate([0,0,-UNDERSIDE_DEPTH-FLOOR_THICKNESS])
	linear_extrude(height = FLOOR_THICKNESS)
	hull() board_2d_positive(BOARD_CORNER_R + CASE_WALL_THICKNESS);
}

module case(MOUNT = "post") {
	difference() {
		case_plain();
		// offset to accomodate weird warpage
		translate([0, 0, WARP_OFFSET])
		components(DO_CUTOUT = true);

		if (MOUNT != "post") {
			// holes for mounting screws
			translate([0,0,-UNDERSIDE_DEPTH-FLOOR_THICKNESS + 1])
			mounting_layout() cylinder(d = MOUNTING_HOLE_DIA * 0.75, h=100);
		}
	}
	if (MOUNT == "post") {
		mounting_layout() sphere_post();
	}
}

module case_vesa(SIZE = 75) {
	case("hole");

	// add base attachment points
	translate([0,0,-UNDERSIDE_DEPTH-FLOOR_THICKNESS])
	linear_extrude(height = FLOOR_THICKNESS)
	vesa(SIZE);
}

// FDMI MIS-D
M4_DRILL = 3.4; // mm
module vesa_holes(SIZE = 75, HOLE_D = 3.4) {
	circle(d = HOLE_D);
	translate([SIZE,0,0])
	circle(d = HOLE_D);
	translate([SIZE,SIZE,0])
	circle(d = HOLE_D);
	translate([0,SIZE,0])
	circle(d = HOLE_D);
}
module vesa_cross(SIZE = 75, HOLE_D = 3.4) {
	hull() {
		circle(d = HOLE_D);
		translate([SIZE,SIZE,0])
		circle(d = HOLE_D);
	}
	hull() {
		translate([SIZE,0,0])
		circle(d = HOLE_D);
		translate([0,SIZE,0])
		circle(d = HOLE_D);
	}
}

module vesa(SIZE = 75) {
	translate([-SIZE/2, -SIZE/2, 0])
	translate([HOLE_W/2, HOLE_H/2, 0])
	difference() {
		vesa_cross(SIZE, M4_DRILL*3);
		vesa_holes(SIZE);
	}
}

// render.py
part = 0;
VESA_SIZE = 75;
if (part == 1) {
	3Aplus();
} else if (part == 2) {
	color("blue") case("hole");
} else if (part == 3) {
	color("blue") case_vesa(VESA_SIZE);
} else if (part == 4) {
	rotate([180,0,0])
	color("pink", alpha = 0.5) lid();
} else {
	3Aplus();
	color("blue") case("hole");
	color("pink", alpha = 0.5) lid();
}
