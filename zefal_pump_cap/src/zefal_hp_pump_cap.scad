// hex_polyhedron.scad may be included in other projects as well. 
//
// I did not author threads.scad, but use it under the CC0 license.
//
// JHH, 2022-2023

include <hex_polyhedron.scad>
include <threads.scad>
include <zefal_hp_rod_guide_and_hose_clip.scad>

$fn=60;

// Lay out parameters for the cap that need to be accurate:
mount_hex_d = 38.0;
mount_circle_d = 40.0;
mount_lip_r = 1.5;
hex_length = mount_hex_d/0.866;
collar_height=18;
fn_count = 60;
cutout_template_height = 29;
top_groove_d = 1;
top_groove_h = 1;
top_cap_id = 13.2;
top_groove_diam = top_cap_id + top_groove_d;


// functions:

module cutting_template(template_height=19) {
  difference() {
    cylinder(d=mount_circle_d+0.6, h=template_height);
    translate([0,0,-0.1]){
      cylinder(d=hex_length, h=template_height + 15, $fn=6);
    }
  }
}


module rounded_hex(collar_height=collar_height) {
  difference() {
    union() {
      cylinder(d = mount_circle_d, h=collar_height, $fn=fn_count*2);
      translate([0,0,0]) {
        scale([1,1,0.3]) {
          sphere(r=mount_circle_d/2, $fn=fn_count*2);
        }
      }
    }
    translate([0,0,-7.1]) {
      cutting_template(template_height=cutout_template_height);
    }
  }
}


module top_gussets(){
  difference() {
    translate([0,0,-1]) {
      for (a = [0:45:90]) {
        rotate([0,0,a]) { cube([3,36,10], center=true); }
      }
      cylinder(h=10.0, r=11, center=true, $fn=8);
    }
    translate([0,0,-6]) {
      difference(){
        translate([0,0,-4]) { cylinder(h=15, d=40, center=true); }
        cylinder(h=7, r1=4, r2=19 , center=true, $fn=8);
      }
    }
  }
}


module pump_cap_cutouts(collar_groove=false) {
  union() {
    translate([0, 0, -10.1]) {
      cylinder(d=top_cap_id, h=31, $fn=fn_count);
    }

    // Two vent holes:
    color("#bb9922") {
      translate([9, 9, 0]){
        cylinder(h=collar_height, r=1.5, center=true, $fn=fn_count/2);
      }
      translate([-9, -9, 0]){
        cylinder(h=collar_height, r=1.5, center=true, $fn=fn_count/2);
      }  
    }
    if(collar_groove==true) {
      translate([0, 0, -collar_height/2 + 5]) {
        cylinder(d=top_groove_diam, h=top_groove_h, $fn=60);
      }
    }

    // chamfer the bottom of the cap interior diameter:
    translate([0,0,collar_height]) {
      color("yellow") {
        translate([0, 0, 0.5]) { 
          rotate([0, 0, 0]) cylinder(h=3, r1=15, r2=21, center=true, $fn=fn_count*2);
        }
      }
    }
  } 
}


module pump_cap() {
  difference(){
    union() {
      rounded_hex();
      top_gussets();
    }
    pump_cap_cutouts();
  }
}


module threaded_pump_cap() {
  difference(){
  ScrewHole(outer_diam=31.7, 
    height=collar_height, pitch=2.5, tooth_angle=60, tolerance=0.4, tooth_height=2)
    pump_cap();
  //translate([0,0,19]) {cylinder(h=20, d=42, center=true);}
  }
}


// main:

//color("#bb99ee"){ threaded_pump_cap(); }
//translate([0,0,-6]) { rotate([0,180,0]) {rod_guide_and_clip(); }}

//pump_cap();
//pump_cap_cutouts();
