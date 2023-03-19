/* Draw a hex solid, with three options: diameter, height, and whether it is
centered on its position or whether point (0,0) is the left and bottom limits
of the shape's extent.

Yes, you can make a cylinder with $fn=6, but I was also learning a few things
and this library became part of several projects, so I will keep it around.

JHH, 2018

*/


m2_5_width = 5.9;
m2_5_depth = 2.1;
m2_5_chamfer = 0.25;

m2_5_bolt_head_diameter = 4.25;
m2_5_bolt_head_height = 2.5;
m2_5_bolt_shaft_diameter = 2.6;

external_bolt_housing_height = 4.5;

module hex_m2_5(centering){
  hex(m2_5_width, m2_5_depth, centering, m2_5_chamfer);
}


module m2_5_bolt (bolt_length, head_height=4) {
  cylinder(d = m2_5_bolt_shaft_diameter + 0.25, h = bolt_length, $fn=20) ;
      translate([0,0,head_height]) {
        cylinder(d = m2_5_bolt_head_diameter + 1, h = 4);
      }
}


module m3bolt(bolt_length, head_depth=4.6) {
  cylinder(d = 3.2, h = bolt_length, $fn=30) ;
      translate([0,0,0]) {
        cylinder(d = 5.5, h = head_depth, $fn=30);
      }
}


function hexpoints(hex_height, halfintang, face_length) =  [
        [0, 0, 0],                      // 0
        [face_length, 0, 0],            // 1
        [face_length, 0, hex_height],   // 2 
        [0, 0, hex_height],             // 3
      
        [face_length + sin(halfintang) * face_length, cos(halfintang) * face_length, 0],          // 4
        [face_length + sin(halfintang) * face_length, cos(halfintang) * face_length, hex_height], // 5

        [face_length, face_length * cos(halfintang) * 2, 0],          // 6
        [face_length, face_length * cos(halfintang) * 2, hex_height], // 7

        [0, face_length * cos(halfintang) * 2, 0],          // 8
        [0, face_length * cos(halfintang) * 2, hex_height], // 9

        [-sin(halfintang) * face_length, face_length * cos(halfintang), 0],         // 10
        [-sin(halfintang) * face_length, face_length * cos(halfintang), hex_height] // 11
      ];


module hex(hex_diam, hex_height, centering, chamfer) {
  face_length = hex_diam / 2;
  intang = 60;
  halfintang = intang / 2;

  offsets = (centering == true) ? [-face_length / 2, - cos(halfintang) * face_length, 0] : [face_length / 2, 0, 0];
  
  translate(v = offsets) {
    hexfaces = [[0, 1,  2, 3],
             [1, 2,  5, 4],
             [4, 5,  7, 6],
             [6, 7,  9, 8],
             [8, 9, 11,10],
             [10,11, 3, 0],
             [3 , 2, 5, 7, 9, 11, 3],
             [0 , 1, 4, 6, 8, 10, 0]
            ];
    
    union() {
      pp = hexpoints(hex_height, halfintang = halfintang, face_length = face_length);
      pc = hexpoints(0.1, halfintang = halfintang, face_length = face_length + chamfer);
      pb = hexpoints(0.25, halfintang = halfintang, face_length = face_length);

      hull(){
        translate([-(chamfer / 2), - cos(halfintang) * (chamfer), hex_height]) {
          polyhedron(points = pc, faces = hexfaces, convexity = 5);
        }
        translate([0,0, hex_height - 0.25]) {
          polyhedron(points = pb, faces = hexfaces, convexity = 5);
        }
      }

      hull() {
        pp = hexpoints(hex_height, halfintang = halfintang, face_length = face_length);
        polyhedron(points = pp, faces = hexfaces, convexity = 5);
      }
    }
  }
}

