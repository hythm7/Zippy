use Zippy::SDL;

my enum Input (

  RETURN =>  40,
  ESCAPE =>  41,
  SPACE  =>  44,
  RIGHT  =>  79,
  LEFT   =>  80,
  DOWN   =>  81,
  UP     =>  82,

);


unit role Zippy::Input;

has %!input;

has SDL_Event $!event .= new;


method read-input ( ) {

  while SDL_PollEvent($!event) {

    given SDL_CastEvent( $!event ) {

      when *.type == KEYDOWN {
        my \key = .scancode;

        if    key ~~ ESCAPE { %!input<ESCAPE> = 1 }
        elsif key ~~ LEFT   { %!input<LEFT>   = 1 }
        elsif key ~~ RIGHT  { %!input<RIGHT>  = 1 }
        elsif key ~~ UP     { %!input<UP>     = 1 }
        elsif key ~~ DOWN   { %!input<DOWN>   = 1 }
      }

      when *.type == KEYUP {
        my \key = .scancode;

        if    key ~~ ESCAPE { %!input<ESCAPE> = 0 }
        elsif key ~~ LEFT   { %!input<LEFT>   = 0 }
        elsif key ~~ RIGHT  { %!input<RIGHT>  = 0 }
        elsif key ~~ UP     { %!input<UP>     = 0 }
        elsif key ~~ DOWN   { %!input<DOWN>   = 0 }
      }
    }
  }
}
