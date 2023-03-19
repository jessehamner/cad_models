// tool rig models and components
//
// JHH, 2022-2023



pen_driver_diam=11.5;
pen_driver_h = 131.5;
pen_driver_clip_top = 110;
pen_driver_clip_length=40;



hex_d = 6.35 + 0.85;
hex_h_1 = 10.5;
hex_h_2 = 11;
hex_collar_h = 4.65;
hex_chamfer = 1.35;

z_head_w =4.5 ;
z_head_h = 5.0 ;
z_head_d =3.2 ;
z_tail_w = 2.5;
z_tail_h = 102 - z_head_h;
z_tail_d = 1.15;


module ziptie() {
  union() {
    cube([z_head_w, z_head_d, z_head_h]);
    translate([(z_head_w/2 - z_tail_w / 2) , 0, -96.9]){
      cube([z_tail_w, z_tail_d, z_tail_h]) ;
    }
  }
}


module three_zipties() {
  translate([2.5,0,97]) {
    ziptie();
    translate([-5,0,0]) { ziptie();}
    translate([-10,0,0]) { ziptie();}
  }
}


module six_zip_cutout() {
  translate([-8.5,0,0]) {
    cube([3 * z_tail_w + 5.5, z_tail_d + 0.5, z_tail_h]) ;
  }
  translate([-8.5,3,0]) {
    cube([3 * z_tail_w + 5.5, z_tail_d + 0.5, z_tail_h]) ;
  }
}


module hex_bit() {
  bitfncount = 50;
  translate([0,0,hex_chamfer]) {
    cylinder(h=hex_h_1, d=hex_d, $fn=bitfncount);
    translate([0,0,-hex_chamfer + delta]){
      cylinder(h=hex_chamfer, r1=(hex_d/2 - 1), r2=hex_d/2, $fn=bitfncount);
    }
    translate([0,0,hex_h_1 - delta]) {
      cylinder(h = hex_collar_h, d = 5.45, $fn=bitfncount);
    }
    translate([0,0,hex_h_1 + hex_collar_h - delta]) {
      cylinder(h = 3.35, d = hex_d, $fn=bitfncount);
    }
    translate([0,0,hex_h_1 + hex_collar_h + 3.35 - delta]) {
      cylinder(h=8, d=3.92, $fn=6);
    }
    translate([0,0,-5]) {
      cylinder(h=8, d=4, $fn=bitfncount);
    }
    translate([0,0,hex_collar_h]) {
      cylinder(h=8, d=hex_d + 0.2, $fn=bitfncount);
    }
  }
}


module hex_insert() {
// at 15 x 51, that's two ranks (though just barely; may need to widen the base some)
// and 51 - 1 - x * (hex_d + 1) evenly divides to 6, so that's 12 bits max.
  h_sp = 1;
  for(x=[1,2,3,4,5,6], y=[-1,1]){
    translate([1 + (x * (hex_d + 1)) , y* (0.5 * hex_d) + y , h_sp]) {hex_bit();}
  }
}

module hex_cap_rounded() {
  s_rad = 1;
  h_cap_y = 22.5;
  h_cap_y_offset = 3;
  h_cap_wall_thickness = 1.5;
  bottom_w = h_cap_y - (2 * s_rad);
  bottom_l = 55 - (2 * s_rad);
  h_sp = 1;  
  bottom_y_inset_offset = -0.2 - bottom_l/2 - (2 * s_rad);
 
  difference() {
    hull() {
      translate([0,0,23]) {
        hull($fn=30) {
          for (x=[-bottom_w/2,bottom_w/2], y=[-bottom_l/2, bottom_l/2]) {
            translate([x, y, 2]) sphere(r=s_rad);
          }
        }
      }
      translate([0,0,-0.02]) {
        hull($fn=30) {
        // 30,20, 4
          for (x=[-bottom_w/2,bottom_w/2], y=[-bottom_l/2, bottom_l/2])
            translate([x, y, 2]) { sphere(r=s_rad);}
        }
      }
    }
// and then remove:  
    union() {
      translate([-7.5,26.3,3]) { rotate([-6,0,0]) {cube([15, 2, 12]); }}
      translate([-7.5,-28.3,3]) { rotate([6,0,0]) {cube([15, 2, 12]); }}
      translate([0, 0 ,1]) { 
        for(y=[1,2,3,4,5,6], x=[-1,1]){
          translate([x * (0.5 * hex_d) + x, 
                     bottom_y_inset_offset + (y * (hex_d + 1)),
                     h_sp]) {hex_bit();}
        }
      }
      translate([-9, (-1 * (h_cap_y + h_cap_y_offset)), 13]) {
        cube([h_cap_y - h_cap_y_offset - 1.5, bottom_l - 2, 30]);
      } 
    }
  }
}


module hex_cap_lip() {
  difference() {
    new_bottom();
    translate([0,29.7,12]) {rotate([0,180,90]) { hex_insert(); }}
  }
}


module socket_driver() {
driver_height = 26;
driver_top = 38;
driver_diam = 12.7;
handle_diam = 6.8;
handle_length = 95;
socket_driver = 6.35;
rod_height=22;

  cylinder(d = driver_diam, h=driver_height, $fn=30);
  translate([0,0,driver_height-delta]) {
    cylinder(r1=driver_diam/2, r2=socket_driver/2, h=4.2, $fn=30);
  }
  translate([-socket_driver/2,-socket_driver/2,driver_top -10]) {
    cube([socket_driver, socket_driver, 10]);
  }
  translate([0,7,rod_height]) {
    rotate([90,0,0]) {
      cylinder(h=handle_length, d=handle_diam, $fn=30);
      translate([0,0,-0.5]){
        cylinder(h=1, d=6.4, $fn=30);
      }
    }
  }
}


module wiha_set() {
wiha_set_w = 50.4;
wiha_set_d = 10 + 0.2;
wiha_set_h = 25.3;

cube([wiha_set_w, wiha_set_d, wiha_set_h]);
}


module hex_set() {
hex_set_h = 31;
hex_set_w = 50.5;
hex_set_d = 17.6 + 0.3;

cube([hex_set_w, hex_set_d, hex_set_h]);
}


module moca() {
  moca_thick = 2.54;
  moca_w = 15.1 + 1;
  moca_h = 68.15;
  cube([moca_w, moca_thick, moca_h]);
}


module tall_moca() {
  moca_thick = 2.54;
  moca_w = 15.1 + 1;
  moca_h = 88.15;
  cube([moca_w, moca_thick, moca_h]);
}


module binder() {
b_thick = 2.54;
b_w = 25;
b_h = 120;

cube([b_w, b_thick, b_h]);
}


module pen_driver() {
  cylinder(h=pen_driver_h, d=pen_driver_diam + 0.3, $fn=30);
  translate([pen_driver_diam/2 + 1.2, 
             -2.0, 
             pen_driver_clip_top - pen_driver_clip_length]){
    cube([3, 4, pen_driver_clip_length]);
  }
}
