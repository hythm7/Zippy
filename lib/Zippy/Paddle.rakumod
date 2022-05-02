use Zippy::Config ( :paddle );
use Zippy::SDL ( :rect :point );


unit class Zippy::Paddle;

has SDL_Point $!xy;
has SDL_Point $!wh;
has SDL_Point $.speed;

has SDL_Rect $.rect handles <x y w h>;

has $.texture;

multi method move-left  ( ) {

	return unless $!rect.x > 0;

  $!rect.shift: -1 * $!speed

}

multi method move-right ( ) {

	return unless $!rect.x < window-width - $!rect.w;

  $!rect.shift: $!speed

}

multi method size-up   ( ) {

	return unless $!rect.w < window-width;

	my $size = SDL_Point.new: $!rect.w / 2, 0;

  $!rect.resize: $size;

	$!rect.shift: -1/2 * $size;
}

multi method size-down ( ) {

	return unless $!rect.w > 4;

	my $size = SDL_Point.new: - ( $!rect.w / 2 ), 0;

  $!rect.resize: $size;

	$!rect.shift:  -1/2 * $size;
}

submethod BUILD( SDL_Point :$xy, SDL_Point :$wh, SDL_Point :$speed, :$texture ) {

	$!xy    = $xy;
  $!wh    = SDL_Point.new: paddle-config<width>, paddle-config<height>; 
  $!speed = SDL_Point.new: paddle-config<speed>, 0; 

  $!rect  = SDL_Rect.new: $!xy.x, $!xy.y, $!wh.x, $!wh.y;

	$!texture = $texture;

}
