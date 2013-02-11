use SDL;
use SDLx::App;
use Modern::Perl;
use SDL;
use SDL::Video;
use SDL::Surface;
use SDL::Rect;
use SDL::Color;
use SDL::Palette;
use SDL::GFX::Primitives;
use SDLx::App;
use Time::HiRes qw( usleep );
use Data::Printer;
use SDL::Event;    #Where ever the event call back is processed
our $app = SDLx::App->new(
    w => 200,
    h => 200,

    #    dt           => .5  ,
    #    min_t => .5,
    title        => 'SDLx Defender',
    delay        => 2,
    resizeable   => 1,
    exit_on_quit => 1,
);

# the size of the window box or the screen resolution if fullscreen
my $screen_width  = 800;
my $screen_height = 600;
our $BROWNA = 0x973914FF;
our $GREENA = 0x00FF00FF;
SDL::init(SDL_INIT_VIDEO);

# setting video mode
my $screen_surface =
  SDL::Video::set_video_mode( $screen_width, $screen_height, 8, SDL_HWPALETTE );

#my $set_colors = SDL::Video::set_colors( $screen_surface, 0  , $BROWNA, $GREENA  );
my $format = $screen_surface->format;
my $pal    = $screen_surface->format->palette;
my $btpp   = $screen_surface->format->BitsPerPixel;
my $bypp   = $screen_surface->format->BytesPerPixel;
my $color  = SDL::Color->new( 255, 0, 100 );

#$canvas->draw_rect( undef, $color );
my $format = $screen_surface->format;
my $pal    = $screen_surface->format->palette;
my $btpp   = $screen_surface->format->BitsPerPixel;
my $bypp   = $screen_surface->format->BytesPerPixel;

# my $aa = SDL::Palette::ncolors();
#warn $aa ;
warn '-------------------------';
p $format;
warn '-------------------------';
p $pal;
warn '-------------------------';
p $btpp;
warn '-------------------------';
p $bypp;
warn '-------------------------';
warn $pal->ncolors;
my @b = SDL::Palette::colors($pal);

#file://localhost/Users/mason/git.wasabi/sdl/sdl.perl.org/SDL-Color.html
#warn $pal->color_index($pal, 0);
#p @b;
#--------------------------------------------
our $BLACKA  = 0x000000FF;
our $REDA    = 0xFF0000FF;
our $BROWNA  = 0x973914FF;
our $GREENA  = 0x00FF00FF;
our $YELLOWA = 0xeda829FF;
our $BLUEA   = 0x141D94FF;
our $PINKA   = 0xCC33FFFF;
our $CYANA   = 0x71fafcFF;
our $GREYA   = 0x818293FF;
our $WHITEA  = 0xFFFFFFFF;

#my $black = SDL::Color->new( 0x00, 0x00, 0x00 );
#my $grey  =  SDL::Color->new( 0xFF, 0xFF, 0xFF );
my $black = SDL::Color->new( 0,   0,   0 );
my $grey  = SDL::Color->new( 255, 255, 255 );
SDL::Video::set_colors( $screen_surface, 0, $black );
my @clrs;
foreach my $i ( 0 .. 255 ) { $clrs[$i] = SDL::Color->new( 0, 0, $i ); }
SDL::Video::set_colors( $screen_surface, 0, @clrs );

#p $clr;
my $clr = SDL::Palette::color_index( $pal, 0 );
my $i = 0;
SDLx::Surface::display( depth => 8 );
$app->add_event_handler( \&get_keyboard_input );
$app->add_move_handler( \&draw );
$app->add_show_handler( sub { $app->update() } );
$app->run();

sub draw {

    #usleep(500000);
    $i = $i == 0 ? 1 : 0;
    warn $i;
    if   ( $i == 1 ) { SDL::Video::set_colors( $screen_surface, 0, $grey ); }
    else             { SDL::Video::set_colors( $screen_surface, 0, $black ); }

    # SDL::GFX::Primitives::hline_color( $screen_surface, 2, 100 , 20 , $clr);
    # SDL::GFX::Primitives::box_color( $screen_surface, 1, 1, 100, 100 , $clr);
    #SDL::GFX::Primitives::hline_color( $screen_surface, 2, 100 , 20 , $clr);
    # update the whole screen
    SDL::Video::fill_rect( $screen_surface, undef, $clr );
    SDL::Video::update_rect( $screen_surface, 0, 0, $screen_width,
        $screen_height );
}

sub get_keyboard_input {
    my ( $event, $app ) = @_;
    if ( $event->type == SDL_KEYDOWN ) {
        my $key_name = SDL::Events::get_key_name( $event->key_sym );
        $app->stop() if $key_name =~ /^q$/;
        $app->stop() if $key_name =~ /escape/;
    }
}
