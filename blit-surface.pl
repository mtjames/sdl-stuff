use strict;
use warnings;

use SDL;
use SDL::Event;
use SDL::Events;
use SDLx::App;
use SDLx::Text;
use SDLx::Rect;
use SDLx::Surface;
use SDL::GFX::Rotozoom;
use SDL::Video;
use SDL::Video;
use SDL::VideoInfo;
use SDL::PixelFormat;
use SDLx::Sprite;
use SDL::GFX::Framerate;
use SDL::GFX::FPSManager;

my $DISPLAY_W = 200;
my $DISPLAY_H = 200;
my $display_surface;

my $DEBUG = 1;
my $SCALE = 1;
my $DISPLAY;


# frames per second
my $fps = 60;
my $timestep = 1.0 / $fps;
my $realFps = $fps;
my $frames  = 1;
my $ticks   = SDL::get_ticks();

#### $fps
# create my main screen
my $app = SDLx::App->new(
    w            => $DISPLAY_W,
    h            => $DISPLAY_H,
    title        => 'SDLx',
    resizeable   => 1,
    exit_on_quit => 1,
);

sub get_keyboard_input {
    my ( $event, $app ) = @_;

    if ( $event->type == SDL_KEYDOWN ) {
        my $key_name = SDL::Events::get_key_name( $event->key_sym );
        $app->stop() if $key_name =~ /^q$/;
        $app->stop() if $key_name =~ /escape/;

        if ( $key_name eq 'tab' ) {
            $SCALE = $SCALE == 1 ? 3 : 1;
            $display_surface = SDL::Video::set_video_mode(
                $DISPLAY_W * $SCALE,
                $DISPLAY_H * $SCALE,
                undef, SDL_SWSURFACE | SDL_RESIZABLE
            );

        }
    }
}

sub display {

    my $i = int( rand(255) ) + 1;
    my $color = SDL::Color->new( 255, 0, $i );
    $app->draw_rect( undef, $color );

    # calc fps
    if ( $frames % $fps == 0 ) {
        my $t = SDL::get_ticks();
        $realFps = $fps / ( $t - $ticks ) * 1000;
        $ticks = $t;
    }

    my $scaled_surface =
      SDL::GFX::Rotozoom::surface( $display_surface, 0, $SCALE, undef );

    SDL::Video::blit_surface( $scaled_surface,
        SDL::Rect->new( 0, 0, $scaled_surface->w, $scaled_surface->h ),
        $display_surface, SDL::Rect->new( 0, 0, 0, 0 ) );

    $realFps = sprintf( "%.1f", $realFps );
    $app->draw_gfx_text( [ 10, 10 ], 0xFFFFFFFF, "fps: $realFps" );

    $app->update;
    $frames++;

}

#----------------------------------------------------------------

# make surfaces

$DISPLAY = SDL::Video::set_video_mode(
    $DISPLAY_W * $SCALE,
    $DISPLAY_H * $SCALE,
    8,
    SDL_HWSURFACE | SDL_HWACCEL | SDL_RLEACCEL | SDL_ASYNCBLIT | SDL_DOUBLEBUF
);

$display_surface = SDLx::Surface->new( surface => $DISPLAY );

$app->add_event_handler( \&get_keyboard_input );
$app->add_show_handler( \&display );
$app->run();

