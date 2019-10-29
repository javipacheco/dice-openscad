/*
 * 6-sided play cube
 */
 
 DRAW_DOTS = 0;
 DRAW_CHATS = 1;
 DRAW_PNG = 2;
 
 // font face
font_face="Arial";
// font style
font_style="Bold";
// size of upper text
font_size=25;

DRAW_TYPES  = [DRAW_CHATS, DRAW_CHATS, DRAW_CHATS, DRAW_CHATS, DRAW_CHATS, DRAW_CHATS];

chars = ["1", "2", "3", "1", "2", "D"];

$fn         = 128 ;
WIDTH       = 64  ;
DOT_DEEP    = 3   ;
DOT_DENSITY = .2  ;
DOT_TABLE   = [
      [  2, [   2, 3, 4, 5, 6 ] ]
    , [  5, [               6 ] ]
    , [  8, [         4, 5, 6 ] ]
    , [  0, [ 1,   3,    5    ] ] ];

tr = [ cos($t*360)*360 , sin($t*360)*360  ];
tc = [ abs(cos($t*360)), abs(sin($t*360)) ];

rotate([tr[0],tr[1],0])
color([tc[0],tc[1],tc[0]*tc[1]])
  playcube();

module playcube()
difference() {
    intersection(){
        cube(WIDTH,center=true);
        sphere(WIDTH*2/3,center=true);
    }

    for(i=[
       [0,0,0]
      ,[1,90,0]
      ,[2,0,90]
      ,[3,0,270]
      ,[4,270,0]
      ,[5,180,0]
    ])
        rotate([i[1],i[2],0])_paint(i[0]);
}

module _paint( n )
    if (DRAW_TYPES[n] == DRAW_DOTS) {
        _dots(n);
    } else if (DRAW_TYPES[n] == DRAW_CHATS) {
        _chart(chars[n]);
    } else if (DRAW_TYPES[n] == DRAW_PNG) {
        _svg(n);
    }

module _dots( n ) {
    for(i=[-1:1],j=[-1:1])
        if(search(n + 1,DOT_TABLE[search(abs(i*3+j*5),DOT_TABLE)[0]][1]))
            _dot(1,DOT_DENSITY*i,DOT_DENSITY*j);
}

module _dot( n, x, y ) {
    translate([WIDTH*x,WIDTH*y,WIDTH*.5-DOT_DEEP])
    cylinder(DOT_DEEP+1,r=WIDTH*.075);
}

module _chart( text ) {
    translate([0,0,WIDTH*.5-DOT_DEEP])
    linear_extrude(height = 4) {
        text(text,font=str(font_face, ":style=", font_style),size=font_size,valign="center",halign="center");
    }
}

module _svg( n ) {
    translate([0,0,WIDTH*.5-DOT_DEEP + 6])
    scale([1, 1, 0.08])
        surface(file = str("draw_", n, ".png"), center = true, invert = true);
    
}