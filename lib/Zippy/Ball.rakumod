use Zippy::Config ( :ball );
use Zippy::SDL ( :rect :point );

unit class Zippy::Ball;

has SDL_Point $!xy;
has SDL_Point $!wh;
has SDL_Point $.speed handles <reflect>;

has SDL_Rect $.rect handles <x y w h>;

has $.texture;

#multi method move  ( ) { $!rect.shift: $!speed }

method move ( ) {

	$!speed.reflect( :over-y ) unless $!rect.w ≤ $!rect.x ≤ window-width  - $!rect.w;
	$!speed.reflect( :over-x ) unless $!rect.h ≤ $!rect.y ≤ window-height - $!rect.h;
  $!rect.shift: $!speed 

}


multi method size-up   ( ) { $!rect.resize:      $!speed }
multi method size-down ( ) { $!rect.resize: -1 * $!speed }

submethod BUILD( SDL_Point :$xy, SDL_Point :$wh, SDL_Point :$speed, :$texture ) {

	$!xy    = $xy;
  $!wh    = SDL_Point.new: ball-config<radius>,   ball-config<radius>; 
  $!speed = SDL_Point.new: 2, ball-config<speed>; 

  $!rect  = SDL_Rect.new: $!xy.x, $!xy.y, $!wh.x, $!wh.y;

	$!texture = $texture;

}
