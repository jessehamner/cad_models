// Printer formatter board access door for a HP Laserjet 400 m401dne
// Part number: RC3-2547 P1-3 (made of ABS plastic)
//
// Jesse Hamner, 2023

abs_thickness = 1.75;
door_h = 99.0 + 0.2;
door_w = 63.0;
door_lip_thickness = 4.75;
door_lip_inner_height = 2.22;
abs_thickness_d = 2.5;
locking_tab_x = 50;

standoff_height = 8.5;
standoff_l = 68;
standoff_w = 57;
standoff_inner_spacing = 59.8;
standoff_offset_l = 10.5;
standoff_offset_w = 2;
standoff_dim = 4.15;

tab_w = 10;
tab_h = 9;
tab_thickness = 2;
tab_pin = 3; // extra length and width of the hinge pin
tab_offset_bottom = 13;
tab_offset_top = 27.5;
tab_inner_spacing = 38.4;
qq = 3;
q = qq * 0.5;

box_d = 19.5;
foot_d = 2.3;
box_and_foot_d = box_d + foot_d;
side_h = 92.5;


module spacer() { cube([standoff_dim, standoff_dim, standoff_height]); }
module door_post() { cylinder(h=door_lip_thickness, d=qq, $fn=30); }



module simple_screw_hole() {
  union() {
    // Hole for the screw:
    translate([0, 0, -10]) {
      cylinder(h=35, d = 4, center=false, $fn=40);
    }  
    // Pass-through hole for a screwdriver:
    translate([0, 0, 4]) {
      cylinder(h=box_and_foot_d + 8, d=7, center=false, $fn=40);
    }
    
    // Countersink:
    translate([0, 0, 0.1]) {
      cylinder(h=4, d1=3, d2=9, center=false, $fn=40);
    }
  }
}
 
 
module screw_holes(){
  translate([0, 0, -3.0]) {
    translate([40, 42.5, 0]) { simple_screw_hole(); }
    translate([80, 10.0, 0]) { simple_screw_hole(); }
    translate([80, 75.0, 0]) { simple_screw_hole(); }
  }
}


module rounded_frame() {
  hull() {
    translate([q, q, 0]) { door_post(); }
    translate([door_h - q, q, 0]) { door_post(); }
    translate([door_h - q, door_w - q, 0]) { door_post(); }
    translate([q, door_w - q, 0]) { door_post(); }  
  }
}


module rounded_frame_punch_out(ir=2.5) {
  q = ir * 0.5;
  hull() {
    translate([q + abs_thickness, q + abs_thickness, abs_thickness_d]) { door_post(); }
    translate([door_h - q - abs_thickness, q + abs_thickness, abs_thickness_d]) { door_post(); }
    translate([door_h - q - abs_thickness, door_w - q - abs_thickness, abs_thickness_d]) { door_post(); }
    translate([q + abs_thickness, door_w - q - abs_thickness, abs_thickness_d]) { door_post(); }  
  }
}


module spacer_pattern() { 
  spacer();
  translate([standoff_l - standoff_dim, 0, 0]) { spacer(); }
  translate([standoff_l - standoff_dim, standoff_w - standoff_dim, 0]) { spacer(); }
  translate([0, standoff_w - standoff_dim, 0]) { spacer(); }
}


module tab_1() {
  difference() {
    cube([tab_w, tab_h, tab_thickness]);

    translate([-3, 7.0, 2]) {
      rotate([-10, 0, 0]) { cube([14, 3, 2]); } 
    }
  }
}


module tab_2() { 
  difference() {
    union() { 
      cube([tab_w, tab_h, tab_thickness]);
      translate([-tab_pin + 1, tab_h, 0]) { cube([tab_h + tab_pin, tab_pin, tab_thickness]);}
    }
    translate([10.5, 9.5, -0.01]) {
      rotate([0, 0, 45]) { cube([2, 4, 2.2]); } 
    }
    translate([-3, 10.0, 2]) {
      rotate([-10, 0, 0]) { cube([14, 3, 2]); } 
    }
  }
}


module locking_tab() { 

  cube([10, 2.15, 15.8]);
  translate([0, -abs_thickness + 1.3, 14.48]) {
    rotate([0, 90, 0]) { rotate([0, 0, 41]) { cylinder(h=10, d=2.8, $fn=3); } }
  }
}


module laserjet_door(screw_holes=false, open_slot=false) {
  difference() {
    rounded_frame();
    rounded_frame_punch_out();
    
    // Open panel to save filament, but let in all the dust:
    if(open_slot==true) {
      translate([10, 10, -5]) { cube([80, 40, 15]); }
    }
    
    // Finger-grip by the locking tab:
    translate([37.6, -0.01, abs_thickness]) { cube([24.15, 1, 6]); }
    
    // Screw holes to enable attaching to the door something with mechanical fasteners:
    if(screw_holes==true) {
      translate([2, 52, -2.5 ]) { rotate([0,180,180]) { screw_holes(); } }
    }
  }

  // Finally, add physical elements to the door:
  
  // spacers:
  translate([standoff_offset_l, standoff_offset_w + 1, 0]) { spacer_pattern(); }
  
  // hanging tabs ("hinges"):
  translate([tab_offset_bottom, door_w, abs_thickness + 1]) { tab_1(); }
  translate([door_h - tab_offset_top - tab_w, door_w, abs_thickness + 1]) { tab_2(); }
  
  // the locking tab:
  translate([locking_tab_x, abs_thickness, 0]) { locking_tab(); }
}

// laserjet_door(screw_holes=true);
