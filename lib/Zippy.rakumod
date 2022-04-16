use Pop;
use Pop::Config;
use Pop::Point :operators;
use Pop::Texture;
use Pop::Textures;


use Zippy::Utils;
use Zippy::Level;
use Zippy::Brick;
use Zippy::Ball;
use Zippy::Paddle;


unit class Zippy;


has Int $!screen-width;
has Int $!screen-height;

has Zippy::Level $!level;

has Zippy::Brick @!brick;
has Zippy::Ball  @!ball;

has Zippy::Paddle $!paddle;


method run ( ) {

	Pop.key-released: -> $_, $ { when 'ESCAPE' { Pop.stop } }

	Pop.update: {

		if    Pop::Inputs.keyboard: 'LEFT'  { $!paddle.move: 'LEFT'  }
		elsif Pop::Inputs.keyboard: 'RIGHT' { $!paddle.move: 'RIGHT' }

    @!ball.map( -> $ball { $ball.move } );

	}

	Pop.render: {

    Pop::Graphics.clear;

		Pop::Graphics.draw: $!level.bg, Pop::Point.zero;

		$!level.brick.map( -> $brick { Pop::Graphics.rectangle: $brick.xy, $brick.xy + $brick.wh, $brick.color, fill => $brick.fill } );

		@!ball.map( -> $ball { Pop::Graphics.circle: $ball.xy, $ball.radius, $ball.color, fill => $ball.fill } );

		Pop::Graphics.rectangle: $!paddle.xy, $!paddle.xy + $!paddle.wh, $!paddle.color, fill => $!paddle.fill;
		
	}

	Pop.run :30fps;

}

method !load( Int :$level = 1 ) {

  Zippy::Level.new: 1;

}

submethod BUILD ( ) {

	Pop.new: |Pop::Config.get( 'window' );

  $!level = self!load: :level<1>;

  $!paddle = Paddle.new;

  @!ball.push: Zippy::Ball.new;
}

