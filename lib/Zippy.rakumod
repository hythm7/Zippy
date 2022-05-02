use Zippy::Config;
use Zippy::SDL;

use Zippy::Level;
use Zippy::Brick;
use Zippy::Ball;
use Zippy::Paddle;
use Zippy::Input;


unit class Zippy;
  also does Zippy::Input;

has SDL_Renderer  $!renderer;

has SDL_Rect      @!dirty;
has @!dirty-brick;

has Zippy::Level $!level;
has Zippy::Ball   @!ball;

has Zippy::Paddle $!paddle;


my $bg-texture; 

method update ( ) {

  if %!input<LEFT> {
    @!dirty.push: $!paddle.rect.clone;
		$!paddle.move-left;
	}
	elsif %!input<RIGHT> {
		@!dirty.push: $!paddle.rect.clone;
		$!paddle.move-right;
	}
	elsif %!input<UP> {
		@!dirty.push: $!paddle.rect.clone;
		$!paddle.size-up;
	}
	elsif %!input<DOWN> {
		@!dirty.push: $!paddle.rect.clone;
		$!paddle.size-down;
	}

	@!ball.map( -> $ball {


		@!dirty.push: $ball.rect.clone;
		#$ball.speed.reflect( :over-x ) if $!level.brick.first( -> $brick { $ball.rect.has-intersection: $brick.rect } );

		#say 'close' if  $!paddle.y ∈ ( $ball.y - $ball.speed.y - $!paddle.h) .. ( $ball.y + $ball.speed.y  + $!paddle.h );

    my @close-x = ( $ball.x - $ball.w ) .. ( $ball.x + $ball.w );
    my @close-y = ( $ball.y - $ball.h ) .. ( $ball.y + $ball.h );

    @!dirty-brick := $!level.brick[ @close-x ; @close-y ];
		#say "ball ", $ball.rect;
		#say "bric ", @!dirty-brick.grep( *.defined );

		$!level.brick[ @close-x ; @close-y ]
		  ==> grep( *.defined )
			==> map( -> $brick  { 
			  next unless $ball.rect.has-intersection: $brick.rect;

				#say "brick ", $brick.rect;
				@!dirty.push: $brick.rect;
		    #say "before ", $ball.rect, $brick.rect;
        $ball.reflect( :over-x );
		    #say "after  ", $ball.rect, $brick.rect;
				$!level.brick[$brick.x][$brick.y] = Empty;
			} );

		if $ball.rect.has-intersection( $!paddle.rect ) {
      
			my $x = 10 * ( $ball.x - $!paddle.rect.center( :x ) ) / $!paddle.w;

		  $ball.reflect( :over-x );
			$ball.speed.add: :$x;
		}

		$ball.move;

	} );

}

method draw ( SDL_Texture:D $texture, SDL_Rect $srcrect, SDL_Rect $dstrect ) {

	SDL_RenderCopy( $!renderer, $texture, $srcrect, $dstrect );

}

method render ( ) {



  @!dirty.map( -> $rect { self.draw: $!level.bg, $rect, $rect } );

  @!dirty-brick.grep( *.defined ).map( -> $brick {

		SDL_SetRenderDrawColor( $!renderer, |$brick.color );
		SDL_RenderDrawRect( $!renderer, $brick.rect );

  } );


  self.draw: $!paddle.texture, SDL_Rect, $!paddle.rect;

  @!ball.map( -> $ball { self.draw:  $ball.texture, SDL_Rect, $ball.rect } );
}

method present ( ) { SDL_RenderPresent $!renderer }

method !load-level ( Levels $level ) {

  my $paddle-x       = ( window-width  - config<paddle><width>  )  ÷   2;
  my $paddle-y       = ( window-height - config<paddle><height> )  - 100;

  my $paddle-xy      = SDL_Point.new: $paddle-x, $paddle-y;
  my $paddle-surface = IMG_Load ~%?RESOURCES<paddle.png>;
	my $paddle-texture = SDL_CreateTextureFromSurface( $!renderer, $paddle-surface );

  my $ball-x       = ( window-width  - config<ball><radius> )  ÷   2;
  my $ball-y       =   window-height - config<ball><radius>    - config<paddle><height> - 100 ;

  my $ball-xy      = SDL_Point.new: $ball-x, $ball-y;
  my $ball-surface = IMG_Load ~%?RESOURCES<ball5.png>;
	my $ball-texture = SDL_CreateTextureFromSurface( $!renderer, $ball-surface );

	$!paddle = Zippy::Paddle.new: xy => $paddle-xy, texture => $paddle-texture;
	@!ball   = Zippy::Ball.new:   xy => $ball-xy,   texture => $ball-texture;


	#my $bg-path    = 'level/' ~ $level ~ '.png';

  my $bg-path = %?RESOURCES{ 'level/' ~ $level ~ '.jpg' };

  my $bg-surface = IMG_Load ~$bg-path;

	my $bg = SDL_CreateTextureFromSurface( $!renderer, $bg-surface );

  self.draw: $bg, SDL_Rect, SDL_Rect;

	my @brick;
	my $brick-path = 'level/' ~ $level ~ '.brk';
  my @brick-data =  %?RESOURCES{ $brick-path }.IO.comb(/ <-[\n]> /).rotor( 96 );

	my \brick-width  = config<level><brick-width>;
	my \brick-height = config<level><brick-height>;

  for ^96 X ^42 -> ( \i, \j ) {

     next unless @brick-data[ j ][ i ];
     next if     @brick-data[ j ][ i ] ~~ ' ';

     my \x = i * brick-width;
     my \y = j * brick-height;

		 my $rect = SDL_Rect.new: x, y, brick-width, brick-height;

		 my $brick = Brick.new: :$rect;
		 @brick[x][y] = $brick; 

		 SDL_SetRenderDrawColor( $!renderer, |$brick.color );
		 SDL_RenderDrawRect( $!renderer, $rect );

	}

  $!level = Zippy::Level.new: :$bg :@brick;

}

method run ( ) {


  my constant frame-time = 1000/60;

	my uint32 $start;
	my uint32 $end;

  my $elapsed;

	self!load-level: Intro;


  loop {

    $start = SDL_GetTicks;

		@!dirty = Empty;

    self.read-input;

    last if %!input<ESCAPE>;

    self.update;

    self.render;

    self.present;

    $end = SDL_GetTicks;
		
		$elapsed = ( $end - $start ) / 1000;
		
		SDL_Delay( floor (frame-time - $elapsed) ) if $elapsed < frame-time;

  }

  SDL_Quit;

}

submethod BUILD ( ) {

  die "couldn't initialize SDL2:       { SDL_GetError }" if SDL_Init( VIDEO ) != 0;
  die "couldn't initialize SDL2_Image: { SDL_GetError }" unless IMG_Init( PNG );

  my constant title  = 'Zippy!';


  my $fullscreen = config<window><fullscreen>;

  my $flags = OPENGL;

	$flags +|= FULLSCREEN if $fullscreen;

	my $window = SDL_CreateWindow(
    title,
    SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK,
    window-width,
    window-height,
    $flags,
  );

  $!renderer = SDL_CreateRenderer($window, -1, 0);

	SDL_RenderSetLogicalSize( $!renderer, window-width, window-height ) if $fullscreen;

}


