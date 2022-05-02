use Pop::Point :operators;
use Pop::Rect;

unit module Zippy::Utils;


our @COLORS is export = (
    # R     G     B
    #[ 0x00, 0x00, 0x00 ], #  0 Black
    [ 0x1D, 0x2B, 0x53 ], #  1 Dark blue
    [ 0x7E, 0x25, 0x53 ], #  2 Dark purple
    [ 0x00, 0x87, 0x51 ], #  3 Dark green
    [ 0xAB, 0x52, 0x36 ], #  4 Brown
    [ 0x5F, 0x57, 0x4F ], #  5 Dark grey
    [ 0xC2, 0xC3, 0xC7 ], #  6 Light grey
    [ 0xFF, 0xF1, 0xE8 ], #  7 White
    [ 0xFF, 0x00, 0x4D ], #  8 Red
    [ 0xFF, 0xA3, 0x00 ], #  9 Orange
    [ 0xFF, 0xEC, 0x27 ], # 10 Yellow
    [ 0x00, 0xE4, 0x36 ], # 11 Green
    [ 0x29, 0xAD, 0xFF ], # 12 Blue
    [ 0x83, 0x76, 0x9C ], # 13 Lavender
    [ 0xFF, 0x77, 0xA8 ], # 14 Pink
    [ 0xFF, 0xCC, 0xAA ], # 15 Light peach
);


role Position   is export { has Pop::Point $.xy     is rw handles < x y > .= zero         }

role Renderable is export {
  has $.color     = @COLORS.pick;
  has Bool $.fill = False;
}

role Body       is export {

	has Bool      $.collideable is rw  = True;
	has Pop::Rect $.hitbox      is rw .= new: 0 

}

role Motion is export {
  has Pop::Point $.delta is rw .= new: 0, 0
}

#role Body is export {
#
#  has Pop::Rect  $.hitbox                               .= new: 0;
#  has Bool       $.solid          is rw                  = True;
#  has Bool       $.collideable    is rw                  = True;
# 
#  method check ( |c --> Bool ) { so $.collide: |c }
#
#  method collide ( $type where * !~~ Body, $x = 0, $y = 0 ) {
#
#    my $hitbox = $!hitbox.translate: self.xy.add( $x, $y );
#
#    Pop::Entities.view(Body, $type).each: -> $e, $_, $ {
#      next if $_ === self || !.collideable;
#      return $e if .hitbox.translate(.xy).collide: $hitbox;
#    }
#    Nil;
#  }
#}
#
#
