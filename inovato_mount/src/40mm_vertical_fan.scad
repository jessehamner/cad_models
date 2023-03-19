
bolt_hole_dist = 35.0;

fan_w = 40;
fan_l = 40;
fan_h = 10.1;

box_side = 5.01;

vent_opening_w = 30.0;
vent_opening_h = 9.25;

fan_opening = 29;
fan_opening_y_offset=2;
screw_curvature_r = 2.5;

dc_y1 = 10.2;
dc_y2 = 15.2;

screw_hole_offset = 2.55;


module fastener_holes(screw_diam=2.75, screw_height=fan_h + 0.1) { 

  translate([screw_hole_offset, screw_hole_offset, -0.01]) {
    cylinder(d=screw_diam, h=screw_height, $fn=30);
  }
  translate([screw_hole_offset, fan_l -  screw_hole_offset, -0.01]) {
    cylinder(d=screw_diam, h=screw_height, $fn=30);
  }
  translate([fan_w - screw_hole_offset, fan_l - screw_hole_offset, -0.01]) {
    cylinder(d=screw_diam, h=screw_height, $fn=30);
  }
  translate([fan_w - screw_hole_offset, screw_hole_offset, -0.01]) {
    cylinder(d=screw_diam, h=screw_height, $fn=30);
  }
}


module no_fastener_mounts(screw_diam=1.5, screw_height=5) {
  fastener_holes(screw_diam=1.5, screw_height=5);
}


module knockout_quarter() { 
  cube([box_side * 0.5 + 0.02, box_side * 0.5 + 0.02, fan_h + 0.05]); 
}


module screw_post_knockouts(){
  union() {
    translate([0, 0, 0.0]) { 
      translate([screw_hole_offset, screw_hole_offset, 0]) {
        cylinder(h=fan_h + 0.03, r=screw_curvature_r, $fn=30);
        difference() {
          translate([-box_side * 0.5, - box_side * 0.5, 0]) {
            cube([box_side, box_side, fan_h + 0.03]);
          }
          translate([0.01, 0.01, -0.01]) { knockout_quarter(); }
        }
      }
      translate([screw_hole_offset, fan_l - screw_hole_offset, 0]) {
        cylinder(h=fan_h + 0.03, r=screw_curvature_r, $fn=30);
        translate([-box_side * 0.5, -box_side * 0.5, 0]) {
        difference() {
            cube([box_side, box_side, fan_h + 0.03]);
            translate([box_side * 0.5 + 0.01, -0.01, -0.01]) { knockout_quarter(); }
          }
        }
      }
      
      translate([fan_w - screw_hole_offset, fan_l - screw_hole_offset, 0]) {
        cylinder(h=fan_h + 0.03, r=screw_curvature_r, $fn=30);
        
        translate([-box_side * 0.5, -box_side * 0.5, 0]) {
        difference() {
            cube([box_side, box_side, fan_h + 0.03]);
            translate([-0.01, -0.01, -0.01]) { knockout_quarter(); }
          }
        }
        
      }
      translate([fan_w - screw_hole_offset, screw_hole_offset, 0]) {
        cylinder(h=fan_h + 0.03, r=screw_curvature_r, $fn=30);
        
        translate([-box_side * 0.5, -box_side * 0.5, 0]) {
        difference() {
            cube([box_side, box_side, fan_h + 0.03]);
            translate([-0.01, box_side * 0.5 + 0.01, -0.01]) { knockout_quarter(); }
          }
        }
        
      }
    }    
  }
}


module art_trim() { 
  // Fan intake:
  translate([fan_opening/2+ fan_opening_y_offset, fan_l/2, fan_h-0.01]) {
    color("#000000") { cylinder(h=0.1, d=fan_opening + 0.5, $fn=60); }
    color("#bbbbbb", alpha=0.1){
      cylinder(h=3, d=fan_opening + 0.5, $fn=60); }
  }

  // Fan vent:
  translate([(fan_w - vent_opening_w)/2, fan_l, 0.4]) { color("#111111") {
    cube([vent_opening_w, 0.6, vent_opening_h + 0.5]); }
    color("#cccccc", alpha=0.1) { cube([vent_opening_w, 4, vent_opening_h + 0.5]); }
  }

  // DC power wires:
  translate([-3.02, fan_l-dc_y2, -0.05]) { color("#111111") { 
    cube([3, dc_y2 - dc_y1, fan_h + 0.1]); }
  }
}

module fan_model(through_holes=true, top_post_knockouts=false) {
  
  difference() {
    union() { 
      color("#555555") { cube([fan_w, fan_l, fan_h]); }
      translate([-0.5, -0.5, 0.01]) { color("#444444", alpha=0.1) {
        cube([fan_w + 1, fan_l + 1, fan_h-0.02]); } 
      }
    }
    translate([0, 0, -8.5]) { screw_post_knockouts();}
    if(top_post_knockouts==true) {
      translate([0, 0,  3.0]) { screw_post_knockouts();}
    }
    if(through_holes==true) {
      translate([0, 0, -0.01]) {fastener_holes(); } 
    }
  }
  art_trim();
}


module socket_test(press_mounts=true, through_holes=false) { 
  difference() {
    translate([-2, -2, -1]) { cube([fan_w + 4, fan_l + 4, fan_h + 0.5]);}
    fan_model(through_holes=through_holes);
    translate([0,0,2]) { screw_post_knockouts(); }
    translate([5, 5, -2]) { cube([30,30,7]); }
    if(through_holes==true) {
      translate([0, 0, -1.5]) { fastener_holes(screw_diam=3); }
    }  
  }

  if(press_mounts==true && through_holes==false){
    no_fastener_mounts(screw_diam=1.5, screw_height=5);
  }
}


// socket_test(through_holes=true, press_mounts=false);
// socket_test(through_holes=false, press_mounts=true);
// no_fastener_mounts(screw_diam=1.5, screw_height=5);
// fastener_holes(screw_diam=3, screw_height=15);
// translate([0,0,15]) { fan_model(through_holes=true, top_post_knockouts=true); }  