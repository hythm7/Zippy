
use Pop::Point :operators;
use Pop::Rect;
use Pop::Texture;
use Pop::Textures;
use Pop::Inputs;
use Pop::Entities;
use Pop::Graphics;

use Zippy::Utils;


unit class Zippy;

constant SCREEN-WIDTH  is export = 900;
constant SCREEN-HEIGHT is export = 700;
constant BRICK-WIDTH   is export = 14;
constant BRICK-HEIGHT  is export = 14;
constant PADDLE-WIDTH  is export = 100;
constant PADDLE-HEIGHT is export = 7;
constant BALL-RADIUS   is export = 7;


class Brick  is export {
  has Bool $.breakable = True;
}

class Ball is export {
  has Int $.radius = BALL-RADIUS;

  has Pop::Point $.speed is rw .= new: 7, 7;
}

class Paddle is export {
  has Pop::Point $.speed is rw .= new: 7, 0;
}


class Room {
	has $.x = 0;
	has $.y = 0;
	has Pop::Texture $.bg;
	has Bool         $.is-title = False;

  submethod TWEAK ( ) {
   
    $!bg = Pop::Textures.load( %?RESOURCES<room/1.png> );

  }
}

my Room  $room;

our sub term:<room> is export { $room }

sub load-room ( $x, $y --> Nil ) is export {


  Pop::Entities.clear;

  create-bricks;
  create-ball;
  create-paddle;




  my Pop::Texture $bg;

	given Pop::Graphics {
		.offset .= zero;

		unless $bg = Pop::Textures.get('level') {
			$bg = Pop::Textures.create: ( SCREEN-WIDTH, SCREEN-HEIGHT ), 'level';
			$bg.blend-mode: 'blend';
		}

		.set-target: $bg;
		LEAVE .reset-target;

		.clear: 0, 0, 0, 0;

	}

  $room = Room.new: :$x :$y :$bg

}

sub create-bricks ( ) {

	for ( 0, * + BRICK-WIDTH ... 490 ) X ( 0, * + BRICK-WIDTH ... 490 ) -> ( $x, $y ) {

		my Pop::Point $xy     .= new: $x, $y; 
		my Pop::Point $wh     .= new: BRICK-WIDTH, BRICK-HEIGHT; 
		my Pop::Rect  $hitbox .= new: :$xy, :$wh;

		Pop::Entities.create: Brick.new, Position.new( :$xy ), Body.new( :$hitbox ), Renderable.new;

	}
}

sub create-ball ( ) {

  my Pop::Point $xy     .= new: SCREEN-WIDTH / 2, SCREEN-HEIGHT - BALL-RADIUS - 100; 
  my Pop::Point $wh     .= new: BALL-RADIUS * 2, BALL-RADIUS * 2;
	my Pop::Rect  $hitbox .= new: :$xy, :$wh;
  my Pop::Point $delta  .= new: 1;

	Pop::Entities.create:
    Ball.new,
    Position.new( :$xy ),
    Body.new( :$hitbox ),
    Motion.new( :$delta ),
    Renderable.new( :fill );

}

sub create-paddle ( ) {

  my Pop::Point $xy     .= new: ( SCREEN-WIDTH - PADDLE-WIDTH ) / 2, SCREEN-HEIGHT - 100; 
  my Pop::Point $wh     .= new: PADDLE-WIDTH,      PADDLE-HEIGHT;
	my Pop::Rect  $hitbox .= new: :$xy, :$wh;
  my Pop::Point $delta  .= new: 1;

	Pop::Entities.create:
		Paddle.new,
		Position.new( :$xy ),
		Motion.new( :$delta ),
		Body.new( :$hitbox ),
		Renderable.new( :fill );

}
