// The Zefal HP bike pump rod guide and hose clip CAD model.
//
// JHH, 2022

epsilon=0.01;
$fn=60;
main_cyl_diam = 16.05;
main_cyl_h = 20.7;
main_cyl_id = 10;
main_cyl_slot_w = 11.6;
main_cyl_slot_d = 2.0;
main_cyl_id_2 = 13.2;
main_cyl_inside_lip_h = main_cyl_h - 2.6;

brace_h = 5.5;
brace_diam = 20;

gusset_height = main_cyl_h - brace_h - 2;
gusset_thickness = 2.25;

connecting_brace_l = 17.4;
connecting_brace_w = 10;
connecting_brace_h = 8.5;
connecting_brace_z_offset = -3;
hose_mount_diam = 11;
hose_mount_od = 17;

mount_spike_h = 8;
mount_spike_d1 = 12.75;
mount_spike_d2 = 14;
mount_spike_barb_h = 4.5;

barb_height = 8.5;
barb_gap=2.0;
barb_ring_gap = 3.4;
barb_post_diam=12.8;


module main_body(original_barbs=false){

  cylinder(d=main_cyl_diam, h=main_cyl_h, center=false);
  cylinder(d=brace_diam, h=brace_h, $fn=60);
  translate([0, 0, connecting_brace_z_offset]) {
    translate([-connecting_brace_w/2, main_cyl_diam/2, 0]) {
      cube([connecting_brace_w, connecting_brace_l, connecting_brace_h]);
    }
    translate([0, main_cyl_diam/2 + connecting_brace_l, 0]) {
      cylinder(d=hose_mount_od, h = connecting_brace_h);
    }
  }

  // The original design included barbs that ride in a groove in the main cap:
  if(original_barbs==true) {
    translate([0, 0, -barb_height + 6]) { barb_foundation(); }
  }
}



module barb_foundation() {
  scale([1,1,1.5]) {
    color("yellow") {
      sphere(r=main_cyl_diam/2, $fn=120);
    }
  }
}


module gusset(angle=0, gusset_y=gusset_thickness) {
  rotate([90,0,angle]) {
    translate([main_cyl_diam/2 - epsilon +0.0, 0, 0]) {
      gusset_points = [[0,0],[gusset_y-0.4,0],[0,gusset_height]];
      linear_extrude(height=gusset_thickness, center=true) polygon(gusset_points);
    }
  }
    
}


module barb_knockouts() {
  translate([0,0, -barb_height - 3.0 - epsilon]) {
    translate([-barb_gap/2, -main_cyl_diam/2, 0]) {
      cube([barb_gap, main_cyl_diam, barb_height+3]); 
    }
    translate([main_cyl_diam/2, -barb_gap/2, 0]) {
      rotate([0,0,90]) {
        cube([barb_gap, main_cyl_diam, barb_height+3]); 
      }
    }
  }
  translate([0,0,-barb_ring_gap + epsilon]) {
    difference() {
      cylinder(h=barb_ring_gap - epsilon, d=barb_post_diam + 5);
      translate([0,0,-0.1]) {
        color("#801111") {
          cylinder(h=barb_ring_gap + 0.1, d=barb_post_diam);
        }
      }
    }
  }
  // trim the bottom of the barbs flat:
  translate([0,0,-20]) {
    cylinder(d=30, h=9);
  }
}


module main_body_knockouts() {
  chamfer_width = 9.8;
  translate([0,0,-0.1]) {
    translate([0,0,-22]) {
      cylinder(h=42, d=main_cyl_id);
    }
    translate([-main_cyl_slot_d/2, -main_cyl_slot_w/2, 0]) {
      cube([main_cyl_slot_d, main_cyl_slot_w, 22], center=false);
    }
    translate([0, hose_mount_diam/2 + connecting_brace_l + 2.75, connecting_brace_z_offset]) {
      cylinder(d=hose_mount_diam, h=connecting_brace_h -connecting_brace_z_offset + 1);
      translate([-hose_mount_od/2, 2.7, 0]) {
        cube([18, 10, connecting_brace_h + 1]);
      }
    }
  }
  translate([0,0, main_cyl_inside_lip_h]) { cylinder(h=5, d=main_cyl_id_2); }
  translate([-chamfer_width/2, 28, connecting_brace_z_offset - 0.1]) { 
    cube([chamfer_width, 1, 9]);
  }
}


module rod_guide_and_clip() {
  difference() {
    union() {
      main_body(original_barbs=false);
      translate([0,0,5.5]) {
        gusset(angle=90, gusset_y=gusset_height-3);
        gusset(angle=0);
        gusset(angle=180);
        gusset(angle=270);
      }
    }
    main_body_knockouts();
    translate([0,0,0.02]) { barb_knockouts(); }
  }
}


//main_body_knockouts();
//barb_knockouts();

//rod_guide_and_clip();
