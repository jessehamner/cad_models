// A very simple mountable box to hold the remote for a 12V LED ribbon.
//
// JHH, 2022

$fn=30;
remote_w = 56;
remote_h = 124.0;
remote_d = 7.1;
remote_slop = 0.6;
wall_thickness = 2;
extra = remote_slop + (wall_thickness * 2);


module remote_model() {
  translate([0, 0, (remote_h + remote_slop) / 2]) {
    cube([remote_w + remote_slop, remote_d + remote_slop, remote_h + remote_slop], center=true);
  }
}


module remote_case() {
  translate([0, 0, (remote_h - extra - 15) / 2]) {
    cube([remote_w + extra, remote_d + extra, remote_h - extra - 15], center=true);
  }

}


module primitive_screwhead(screw_diam = 3) {
  union() {
    cylinder(r1=screw_diam * 1.2, r2=screw_diam/2, h=wall_thickness + 0.6);
    translate([0,0, screw_diam]) cylinder(d=screw_diam * 1.1, h = screw_diam * 5); 
  }
}


module screw_cutouts() {
  backout = -3.35;
  
  translate([0, backout, 80]) {
    rotate([90,0,0]) {
      primitive_screwhead(screw_diam=4);  
    }
  }
  translate([20, backout, 95]) {
    rotate([90,0,0]) {
      primitive_screwhead(screw_diam=4);  
    }
  }
  translate([-20, backout, 95]) {
    rotate([90,0,0]) {
      primitive_screwhead(screw_diam=4);  
    }
  }
}


module case_cutout() {
  difference() {
    translate([0, 0, 0]) { remote_case(); }
    union() {
      translate([0, 0, wall_thickness ]) { remote_model(); }
      translate([0, 6, remote_h - 20]) {
        scale([1,1,1.5]) { 
          rotate([90,90,0]){
            cylinder(h=3, d = remote_w + 0.5, $fn=60); 
          }
        }
      }
      
      translate([-remote_w / 2 + wall_thickness + 2, 0, 0]) {
        for (a = [0: 6: 48]) {
          translate([a, 0, -6 + wall_thickness * 2]) { 
            cube ([4, remote_d -1, 30], center = true) ; 
          }
        }
      }
      screw_cutouts();
    }
  }
}

case_cutout();
