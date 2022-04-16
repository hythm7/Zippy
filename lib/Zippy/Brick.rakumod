use Pop::Point :operators;

use Zippy::Utils;


unit class Zippy::Brick;

has Pop::Point $.xy handles < x y > .= zero;

has Pop::Point  $.wh .= new: 0;

has $.color = @COLORS.pick;

has Bool $.breakable = True;
has Bool $.fill      = False;
