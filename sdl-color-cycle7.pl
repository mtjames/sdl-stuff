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

use Smart::Comments;
use Data::Printer;
use Data::Dumper;


our $app = SDLx::App->new(

    dt           => .5  ,
    min_t => .5,

    depth => 8,
    delay        => 2,
    resizeable   => 1,
    exit_on_quit => 1,
);

# the size of the window box or the screen resolution if fullscreen
my $screen_width  = 640;
my $screen_height = 480;

my $x = 0;


SDL::init(SDL_INIT_VIDEO);

# setting video mode
my $screen_surface =
  SDL::Video::set_video_mode( $screen_width, $screen_height, 8, SDL_HWSURFACE| SDL_HWPALETTE );

#my $set_colors = SDL::Video::set_colors( $screen_surface, 0  , $BROWNA, $GREENA  );
my $format = $screen_surface->format;
my $pal    = $screen_surface->format->palette;
my $btpp   = $screen_surface->format->BitsPerPixel;
my $bypp   = $screen_surface->format->BytesPerPixel;
#my $color  = SDL::Color->new( 255, 0, 100 );


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



my @clrs;
foreach my $i (0..255) {
    $clrs[$i] = SDL::Color->new( $x,   0,   $i );

}


my $img = SDL::Image::load( 'fractal.gif' );
$app->blit_by( $img, undef, undef  );
$app->flip();


# -----------------------------------
$app->add_event_handler( \&get_keyboard_input );
$app->add_move_handler( \&draw );
#$app->add_show_handler( sub { $app->update() } );
$app->run();

# -----------------------------------
sub draw {

        my @clrs;
        foreach my $i (0..255) {
            $clrs[$i] = SDL::Color->new( $x,   0,   $i );


        }


        my $rc =  SDL::Video::set_palette( $screen_surface,  SDL_PHYSPAL  ,  0, @clrs );


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
