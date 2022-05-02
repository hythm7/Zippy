use Config::TOML;

constant config is export = from-toml slurp %?RESOURCES<config.toml>;

constant window-width   is export = config<window><width>;
constant window-height  is export = config<window><height>;

constant paddle-config  is export( :paddle ) = config<paddle>;
constant ball-config    is export( :ball   ) = config<ball>;
