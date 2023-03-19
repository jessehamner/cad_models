
railgreen = "#227711";
railblue = "#7788cc";

// parametric setup:
wall_thickness = 2;
floor_thickness = 1;
epsilon = 0.01;
mount_rail_height = 64; // This is specific to your particular hanging surface


m_inner_x = 57.9;
m_inner_y = 22.1;
case_height = 60;
case_depth = m_inner_y + (2 * wall_thickness);
case_width = m_inner_x + (2 * wall_thickness);

hook_top_thickness = 4;
hook_height = 10;
hook_width = 9;
hook_count = 2;
plate_thickness = 6.7; // how wide is the "wall" on which you'll be hanging this holder?
hook_y = plate_thickness + hook_top_thickness;

bottom_vent_count = 6;
bottom_vent_width = 7;
bottom_vent_spacing = 2;
bottom_vent_border_thickness = 0.5;

hook = true;

// Coordinates of an approximate contour / profile for the Magic Mouse:
mouse_profile_max_z = 43;
mouse_profile = [[-11, mouse_profile_max_z + epsilon], 
                 [-10.9, 15], [-8.5, 12], [-8.0, 9], [-7.5, 6], [-6.3, 4], 
                 [-5, 1], [-4,0], [-3, 2], [-2, 3], [-1, 4], [1.9, 7.5], 
                 [2.8, 9.5], [3.8, 11.0], [5.4, 15], [7, 18], [8.3, 24], [10, 30],
                 [11.2, 38.01], [12, mouse_profile_max_z + epsilon]
                ];


// The xshift value offsets the vents from the x-sides to ensure vent placement and spacing
// work nicely. The wall thickness (from one side) is added to the remainder of 
// ( (count of vents) * (vent width) + (count of vents + 1) * (vent gap width) ) / 2
xshift= wall_thickness + bottom_vent_spacing +
   (m_inner_x - (bottom_vent_count * bottom_vent_width) - 
   (bottom_vent_count + 1) * bottom_vent_spacing)/2;


// polygon profile of the fattest slice of the front of the Magic Mouse II:
module magic_mouse_profile() {
  rotate([90,0,90]) {
    linear_extrude(height=bottom_vent_spacing + 2 * epsilon) {
      polygon(points=mouse_profile);
    }
  }
}


function hook_v_off(case_height=case_height, mount_rail_height=mount_rail_height) = 
  (case_height - mount_rail_height <= 0) ? 0 : case_height - mount_rail_height; 


module body_inset(xshift) {
    union() {
    // Cut away the pocket for the mouse:
    translate([wall_thickness, wall_thickness, floor_thickness]){
      color("saddlebrown") {
        cube([m_inner_x, m_inner_y, case_height]);
      }
    }
    
    // Cut away the charging port hole:
    translate([25, -epsilon, 19]) {
      cube([12, wall_thickness + (2 * epsilon), 9]);
    }
    
    // Cut slots in the bottom so dust doesn't collect:
    for(xval = [0:1:bottom_vent_count - 1]) {
      translate([xshift + xval * (bottom_vent_width + bottom_vent_spacing),
                 wall_thickness + bottom_vent_border_thickness,
                 -epsilon
                ]) {
        cube([bottom_vent_width, m_inner_y - (2 * bottom_vent_border_thickness), 2]);
      }
    }

    // No need for a solid rail; use discrete "hooks" by cutting them out:
    gap_width = (case_width - hook_width * hook_count) / (hook_count - 1) ;
    if (hook==true) {
      for(xval = [0:1:(hook_count - 2)]) {
        translate([hook_width + (hook_width + gap_width) * xval, 
                   case_depth + epsilon,
                   case_height - hook_height - hook_top_thickness - hook_v_off()
                  ]) {
          cube([gap_width, hook_y + epsilon , hook_height + hook_top_thickness]);
        }
      }
    }
  }
}


module all_the_rails(xshift) {
  // inner rails, but skip the middle rail because of the Lightning charge port.
  // Also skip the outermost rails because there will be straight outer rails, below.
  for(xval = [1:1:(bottom_vent_count)/2 - 1]) {
    translate([xshift + xval * (bottom_vent_width + bottom_vent_spacing) - bottom_vent_spacing, 
               m_inner_y + wall_thickness - 12.7,
               floor_thickness]) {
      color(railgreen) {
        contour_rail();
      }
    }
  }
  starting_x = ((bottom_vent_count)/2) + 1;
  for(xval = [starting_x:1:bottom_vent_count - 1]) {
    translate([xshift + xval * (bottom_vent_width + bottom_vent_spacing) - bottom_vent_spacing, 
               m_inner_y + wall_thickness - 12.7,
               floor_thickness]) {
      color(railgreen) {
        contour_rail();
      }
    }
  }
  
  // Make outer rails to accommodate the narrower profile on the edges of the mouse:
  color(railblue) {
    translate([wall_thickness - epsilon - 0.2,
               wall_thickness + 5,
               floor_thickness
              ]) {
      cube([bottom_vent_spacing + 1 , 4.0, 24 + floor_thickness]) ; 
      translate([0, m_inner_y - 12, 0]) { 
        cube([bottom_vent_spacing + 1, 4, 26 + floor_thickness]) ; 
      }
    }
    translate([wall_thickness + m_inner_x - bottom_vent_spacing + 0.2 - 1,
               wall_thickness + 5,
               floor_thickness]) {
      cube([bottom_vent_spacing + 1, 4.0, 24 + floor_thickness]) ;
      translate([0, m_inner_y - 12, 0]) {
        cube([bottom_vent_spacing + 1, 4, 26 + floor_thickness]) ;
      }
    }
  }
}


// contoured ribs to hold the mouse, rather than only the bottom and tallest point on top.
module contour_rail() {
  translate([0, -11, -0.99]) {
    cube([bottom_vent_spacing, m_inner_y + 3, 3.01]);
    translate([0,-2,0]) {
      //cube([bottom_vent_spacing, 2, mouse_profile_max_z]);
    }
  }
  difference() {
    translate([0,-11,0]) {
      cube([bottom_vent_spacing,m_inner_y + 3, mouse_profile_max_z]);
    }
    translate([-epsilon, 0, 0]) {
      magic_mouse_profile();
    }
  }  
}



module solid_outline() {
  union() {
    cube([case_width,
          case_depth, 
          case_height]);
    if (hook == true) {
      mount_rail();  
    }
  }
}


module mount_rail() {
  translate([0, case_depth - 0.1, case_height - hook_height - epsilon - hook_v_off()]) {
    difference(){
      cube([case_width, hook_y, hook_height]);
      translate([- epsilon, 0, -0.1]) {
        color("yellow") {
          cube([case_width + (2 * epsilon), 
                plate_thickness,
                hook_height - hook_top_thickness
               ]);
        }
      }
    }
  }
}


module complete_model(xshift, include_rails=true) {
  difference() {
    solid_outline();
    body_inset(xshift);
  }
  if(include_rails==true) {
    all_the_rails(xshift);
  }
}


// main:

complete_model(xshift=xshift, include_rails=true);

