// Inovato quadra vertical sleeve-type mount

// open BOTTOM for vertical air flow upward through case
// orientation: SD card slot & side USB A port face UP
// all other ports face REAR and must be accessible

include <./hp_lj_door.scad>
include <./40mm_vertical_fan.scad>

side_w = 92.5;
side_h = 92.5;
box_d = 19.5;
foot_d = 2.3;
box_and_foot_d = box_d + foot_d;
pinstripe_gap = 1.4;
bottom_pinstripe_w = 3.62;
pinstripe_w = 3.93;
pinstripe_d = 0.5;
gap_to_gap = 90.5;
rear_side_trim = 6.5;
rear_port_opening_height = 15;


module rail() { cube([side_w - 5, 3, foot_d + 0.3]); }


module support_rails() { 
  union() {
    translate([0, 20, 0]) { rail(); } 
    //translate([0, 60, 0]) { rail(); } 
    translate([0, 60, 0]) { rail(); } 
  }
}


module plate(extra_height=0) { 
  cube([side_w + 2.9, side_w + 1.5, pinstripe_w + extra_height]);
}


module lens() {
  scale([0.7, 5.2, 1]) {   
    cylinder(h = 8, d= box_d - 5, center=false, $fn=80); 
  }
}


// Messing around with saving filament while still providing
// pass-through access for a screwdriver, but the print will take longer.
module lens_pattern() { 
  translate([45, 0, box_and_foot_d - 5]) { 
    translate([0, 42.5, 0]) { rotate([0, 0, 90]) { lens(); } }
    translate([0, 75.0, 0]) { rotate([0, 0, 90]) { lens(); } }
    translate([0, 10.0, 0]) { rotate([0, 0, 90]) { lens(); } }
  }
}


module simple_screw_hole() {
  union() {
    // Hole for the screw:
    translate([0, 0, -4]) {
      cylinder(h=30, d = 4, center=false, $fn=40);
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


module new_box_model() {
  color("saddlebrown") {
    union() {
    
      // Four plates to rough out the enclosure:
      translate([0,0, -2.0]) {
        plate(extra_height=2.0);
      }
      translate([0,0, bottom_pinstripe_w + pinstripe_gap]) { 
        plate(extra_height=0.3);
      }
      translate([0,0, bottom_pinstripe_w + 2 * pinstripe_gap + pinstripe_w]) {
        plate(extra_height=0.3);
      } 
      translate([0,0, 3 * (pinstripe_gap + pinstripe_w) - 0.3]) {
        plate(extra_height=0.5);
      }
      
      // Inner "box" to fill in between plates and make the grooves:
      translate([1.0, 1.0, -0.99]) {
        cube([gap_to_gap + 3.9, gap_to_gap + 1.5, box_d + 1.59]);
      }
      
      // One side has interrupted gaps between plates:
      translate([pinstripe_d + rear_side_trim, 0, -0.99]) {
        cube([ gap_to_gap - 2.1, 20, box_d + 1.59]);
      }
    }
  }
}


module case_cutout(screw_holes=true, reverse_screw_holes=false) { 
  difference() {
    union() {
      // Primary cutout for enclosure is a rough facsimile of the actual case:
      translate([0.4, -0.9, 2]) { new_box_model();}
        
      // bottom opening for convective cooling:
      color("#228822") {
        translate([-2.1, rear_side_trim, 2.6]) {
          cube([side_w + 6, side_w - (2 * rear_side_trim), box_d - 2]);
        }
      }
      
      color("yellow") {
        // rear ports cutout:
        translate([rear_side_trim, -3.1, 5]) { 
          cube([side_w -20, 6, box_d - 4]); 
        }
        translate([side_w - 13.5, 2.7, (box_d - 6.75)]) { 
          rotate([90, 0, 0]) { cylinder(h = 5.8, d= box_d - 4, center=false, $fn=80); }
        }
        
        // Countersunk screw holes:
        if(screw_holes == true) {
          if(reverse_screw_holes == true) {
            translate([0, side_h - 7.3, box_d + 2.1]) {
              rotate([0,180,180]) { screw_holes(); } 
            }
          } else {
            screw_holes();
          }
        }
      }
    }
    
    // Knock out bottom rails to "leave" support rails 
    // for the enclosure with minimal material:
    color("#9999ee") {
      translate([0, 1, -0.02]) {
        support_rails();
      }
    }
  }
}


module dev_chopoff() { translate([25, -4, -4]) { cube([100, 100, 30]);} }


module case_enclosure(dev_chopoff=false, screw_holes=true, reverse_screw_holes=false) { 
  difference() { 
    // Outer limits of the enclosure:
    translate([-2, -3, -2.5]) { 
      cube([side_w, side_h + 6 , box_d + 7.5]);
    }
    
    union() {
      case_cutout(screw_holes=screw_holes, reverse_screw_holes=reverse_screw_holes);
      if(dev_chopoff==true) {
        dev_chopoff();
      }
    }
  }
}


module case_enclosure_with_fans() { 
  rotate([0,-90,0]) {
    case_enclosure(dev_chopoff=false, screw_holes=true, reverse_screw_holes=true); 
    rotate([0,0,-90]) {
      translate([-45,-43, 6]) {
                   socket_test();
                   no_fastener_mounts(screw_diam=1.5, screw_height=5);
      }
      translate([-89, -43, 6]) {
                socket_test();
                no_fastener_mounts(screw_diam=1.5, screw_height=5);
      } 
    }
  }

  translate([-3,3.01,-4.5]) { rotate([-90,0,0]) {
      difference() { 
        union() {
          color("#666600") { cylinder(d=8, h=88, $fn=6); }
          color("#eeee00") { translate([1,-3,-0.01]) { cube([3,3,88.02]);} }
        }
        translate([-5.1,-4,-0.1]) {cube([3, 12,88.5]);} 
      }
    }
  }
  
}


  
//  case_enclosure_with_fans();
// case_enclosure(dev_chopoff=false, screw_holes=true, reverse_screw_holes=true);
// rotate([0, -90,0]) { case_enclosure(dev_chopoff=false, screw_holes=true, reverse_screw_holes=false); }
// case_cutout();
// new_box_model();
// translate([0, side_h - 7.3, box_d + 2.1 + 1.4]) { rotate([0,180,180]) { screw_holes(); } }
// translate([-9, 34 , box_d + 4.99]) { laserjet_door(); }

case_enclosure(dev_chopoff=false, screw_holes=true, reverse_screw_holes=true);
translate([-2, 33, box_d + 4.99]) {laserjet_door(screw_holes=true); }
