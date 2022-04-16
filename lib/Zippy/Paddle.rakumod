use Pop::Config;
use Pop::Point :operators;
use Pop::Rect;

use Zippy::Utils;

my \screen-width  = Pop::Config.get( 'window' ).<width>;
my \screen-height = Pop::Config.get( 'window' ).<height>;
my \paddle-speed  = Pop::Config.get( 'paddle' ).<speed>;
my \paddle-width  = Pop::Config.get( 'paddle' ).<width>;
my \paddle-height = Pop::Config.get( 'paddle' ).<height>;

unit class Zippy::Paddle;

has Pop::Point $.xy handles < x y > .= new: ( screen-width - paddle-width ) / 2, screen-height - 100;
has Pop::Point $.wh                 .= new: paddle-width, paddle-height;
has Pop::Point $.speed              .= new: 7, 0;

has $.color     = @COLORS.pick;
has Bool $.fill = True;

multi method move ( 'LEFT'  ) { $!xy -= $!speed }
multi method move ( 'RIGHT' ) { $!xy += $!speed }

