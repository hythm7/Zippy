
use Zippy::Brick;


enum Levels (

  Intro   => 0,
  Welcome => 1,

);

unit class Zippy::Level;

has              $.bg;
has @.brick


#
#
#  my $brick-data =  %?RESOURCES{ $brick-path }.slurp;
#
#  my @data = $brick-data.comb( / \d / ).rotor( 60 );
#
#  my @brick;
#
#
#  for ^60 X ^10 -> ( \i, \j ) {
#
#    next unless @data[ j ][ i ];
#
#    my Pop::Point $ij .= new: i, j;
#
#    my Pop::Point $wh .= new: brick-width, brick-height;
#
#    my Pop::Point $xy = $ij * $wh;
#
#    @brick.push: Zippy::Brick.new: :$xy :$wh;
#
#  }
#
#  self.bless: bg => Pop::Textures.load( %?RESOURCES{ $bg-path } ), :@brick;
#
#}
