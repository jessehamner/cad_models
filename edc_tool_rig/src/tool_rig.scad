// a 3d-printable rack for EDC tools in my bag
// JHH, 2022
include <tool_components.scad>

// Global variables:
delta=0.01;


module new_bottom() {
  bottom_w = 14.05;
  bottom_l = 47;

  hull() {
  translate([0,0,8.5]) {
    hull($fn=30) {
      for (x=[-bottom_w/2,bottom_w/2], y=[-bottom_l/2, bottom_l/2]) {
        translate([x, y, 2]) sphere(r=2);
      }
    }
  }

  translate([0,0,-0.05]) {
    hull($fn=30) {
    // 30,20, 4
      for (x=[-bottom_w/2,bottom_w/2], y=[-bottom_l/2, bottom_l/2])
        translate([x, y, 2]) { sphere(r=2);}
      
      }
    }
  }
}


module insets2() {
  union() {
    translate([0.0,-7,89]) { rotate([90,0,0]) socket_driver();}
    translate([9, 1, 2]) {rotate([0,-90,90]) {wiha_set(); }}
    translate([-6.5, -2, 56]) { rotate([0,0,0]) { moca(); }}
//    translate([-14, -7, -5]) { rotate([0,0,90]) { binder(); }}
    translate([-1.19, -20, 0.5]) { rotate([0,0,90]) {tall_moca();}}
    translate([0, pen_driver_diam/2 + 3, 0.5]) { pen_driver();}
    translate([-10, -11.5, 50]) {
      scale([1, 1.0 , 1.4]) rotate([90,0,90]) {cylinder(d=20, h=20, $fn=50); }
    }
    translate([0,-15 + 1 , 1.99]) { scale([1.00, 1.8 , 1.2]) cylinder(d=12, h=95, $fn=30);}
    //translate([-10, -24.0, 65]) {rotate([0,0,0]) {cube([30, 20, 3]); }}
    translate([2,16.0,12]) {
      six_zip_cutout();
    }
    translate([-10, 23.0, 12]) { 
      rotate([90,0,90]) { 
        scale([1.3, 1.4 , 1.0]) {
          cylinder(h = 20, d = 10, $fn=30);
        }
      }
    }
  }
}


module holder_model_2() {
  difference() {
    the_wide_box();
    color("#FFFF0099"){ insets2(); }
  }
}


module the_wide_box() {
  hull() {
    translate([0,0,86.15]) {
      hull($fn=30) {
        for (x=[-5.5,5.5], y=[-33,20]) {
          translate([x, y, 2]) sphere(r=2);
        }
      }
    }

    translate([0,0,6.15]) {
      hull($fn=30) {
        for (x=[-5.5,5.5], y=[-33,20]) {
          translate([x, y, 2]) sphere(r=2);
        }
      }
    }
  }
    
  hull() {

    translate([0,0,7]) {
      hull($fn=30) {
      // 30,20, 4
        for (x=[-6.5,6.5], y=[-34,15]) {
          translate([x, y, 0])
            cylinder(r=1, h=2);
        }
      }
    }
    translate([0,0,-0.05]) {
      hull($fn=30) {
      // 30,20, 4
        for (x=[-6.5,6.5], y=[-34,15]) {
          translate([x, y, 0])
            cylinder(r=1, h=2);
        }
      }
    }
    translate([0,0,2.25]) {
      hull($fn=30) {
        for (x=[-6.5,6.5], y=[4,20]) {
          translate([x, y, 2]){ scale([1,1,2]) {sphere(r=1);}}
        }
      }
    }
  }
  translate([0,-9.5,-10.5]) {color("#9999ee") {hex_cap_lip();}}
}


holder_model_2();
//insets2();
color("#ccbb66bb") {translate([0,-9.5,-39]) {rotate([0,0,0]) {hex_cap_rounded();}}}
