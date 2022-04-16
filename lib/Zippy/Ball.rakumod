use Pop::Config;
use Pop::Point :operators;

use Zippy::Utils;

my \screen-width  = Pop::Config.get( 'window' ).<width>;
my \screen-height = Pop::Config.get( 'window' ).<height>;
my \ball-radius   = Pop::Config.get( 'ball'   ).<radius>;

unit class Zippy::Ball;

has Pop::Point $.xy handles < x y > .= new: screen-width / 2, screen-height - ball-radius - 100;

has Pop::Point $.speed  .= new: 7;

has Int $.radius = ball-radius;

has $.color     = @COLORS.pick;
has Bool $.fill = True;

method move ( ) {

	$!speed *= ( -1,  1 ) unless 0 ≤ $!xy.x ≤ screen-width;
	$!speed *= (  1, -1 ) unless 0 ≤ $!xy.y ≤ screen-height;
	$!xy -= $!speed;

}
