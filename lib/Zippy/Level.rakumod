use Pop::Config;
use Pop::Point :operators;
#use Pop::Graphics;
use Pop::Textures;
#use Pop::Texture;

use Zippy::Brick;

unit class Zippy::Level;

has Pop::Texture $.bg;

has Zippy::Brick @.brick;

method new ( Int $id ) {

  my $width  = Pop::Config.get( 'level' ).<width>;
  my $height = Pop::Config.get( 'level' ).<height>;
 

  my $bg-path    = 'level/' ~ $id ~ '.png'; 
  my $brick-path = 'level/' ~ $id ~ '.brk'; 

  my $brick-data =  %?RESOURCES{ $brick-path }.slurp;

  my @data = $brick-data.comb( / \d / ).rotor( 60 );

  my @brick;

  my $brick-width  = Pop::Config.get( 'brick' ).<width>;
  my $brick-height = Pop::Config.get( 'brick' ).<height>;

  for ^60 X ^1 -> ( \i, \j ) {

    next unless @data[ j ][ i ];

    my Pop::Point $ij .= new: i, j;

    my Pop::Point $wh .= new: $brick-width, $brick-height;

    my Pop::Point $xy = $ij * $wh;

    my Pop::Rect $rect .= new: :$xy :$wh;

    @brick.push: Zippy::Brick.new: :$xy :$wh;

  }

  self.bless: bg => Pop::Textures.load( %?RESOURCES{ $bg-path } ), :@brick;

  #my Pop::Texture $bg;

	#given Pop::Graphics {

	#	LEAVE .reset-target;

	#	.offset .= zero;

  #  unless $bg = Pop::Textures.get('level') {

	#	  $bg = Pop::Textures.create: ( $width, $height ), 'level';
	#	  $bg.blend-mode: 'blend';

  #  }

	#	.set-target: $bg;

	#	.clear: 0, 0, 0, 0;


	#}


}
