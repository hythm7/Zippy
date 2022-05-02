unit class Zippy::Brick;

has $.rect handles <x y w h>;
has @.color = (^254).pick, (^254).pick, (^254).pick, (^254).pick;
has Bool $.breakable = True;
