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

#use SDLx::App;
use Time::HiRes qw( usleep );
use Data::Printer;
use SDL::Event;    #Where ever the event call back is processed
use Smart::Comments;
use Data::Printer;
use Data::Dumper;
use SDL ':init';
use SDL::Event;
use SDL::Events ':all';
SDL::init(SDL_INIT_VIDEO)
  ;                # Event can only be grabbed in the same thread as this

# the size of the window box or the screen resolution if fullscreen
my $screen_width  = 640;
my $screen_height = 480;
my $x             = 0;

# setting video mode
my $screen_surface =
  SDL::Video::set_video_mode( $screen_width, $screen_height, 8,
    SDL_SWSURFACE | SDL_HWPALETTE );
my @clrs;
foreach my $i ( 0 .. 255 ) { $clrs[$i] = SDL::Color->new( $x, 0, $i ); }
my $img = SDL::Image::load('fractal.gif');

#$app->blit_by( $img, undef, undef );
SDL::Video::blit_surface( $img, undef, $screen_surface, undef );
my $event = SDL::Event->new();    # notices 'Event' ne 'Events'
while (1) {
    SDL::Events::pump_events();
    while ( SDL::Events::poll_event($event) ) {

        #check by event type
        exit if $event->type == SDL_QUIT;
    }
    draw();
}

# -----------------------------------
sub draw {
    my @clrs;
    foreach my $i ( 0 .. 255 ) { $clrs[$i] = SDL::Color->new( $x, 0, $i ); }
    my $rc = SDL::Video::set_palette( $screen_surface, SDL_PHYSPAL, 0, @clrs );
    $x++;
    $x = 0 if $x == 255;
    warn $x;
}

sub get_keyboard_input {
    my ( $event, $app ) = @_;
    if ( $event->type == SDL_KEYDOWN ) {
        my $key_name = SDL::Events::get_key_name( $event->key_sym );
        $app->stop() if $key_name =~ /^q$/;
        $app->stop() if $key_name =~ /escape/;
    }
}
