use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;
plugin 'SemanticUI';

get '/' => sub {
  my $c = shift;
  $c->render(text => 'Hello Mojo!');
};

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_is('Hello Mojo!');

# Testing if assets are found and served
our $base         = '/vendor/SemanticUI/components/';
our $served_files = {};
subtest 'behaviors' => sub {
  my $path = $base;
  for my $file (qw(api colorize form state visibility visit)) {
    $t->get_ok($path . $file . '.min.js')->status_is(200)->content_like(qr/function/x);
    $served_files->{$file . '.min.js'} = 1;
  }
};
subtest collections => sub {
  my $path = $base;
  for my $file (qw(breadcrumb form grid menu message table)) {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/\.ui\.$file/x);
    $served_files->{$file . '.min.css'} = 1;
  }
};

subtest elements => sub {
  my $path = $base;
  for my $file (
    qw(button divider flag header icon image input label list
    loader progress reveal segment step rail)
    )
  {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/(\.ui\.)?$file/x);
    $served_files->{$file . '.min.css'} = 1;
  }
};
subtest globals => sub {
  my $path = $base;
  for my $file (qw(reset site)) {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/semantic-ui/x);
    $served_files->{$file . '.min.css'} = 1;

  }
  $t->get_ok($path . 'site.min.js')->status_is(200)->content_like(qr/function/x);
  $served_files->{'site.min.js'} = 1;
};
subtest modules => sub {
  my $path = $base;
  for my $file (
    qw(accordion chatroom checkbox dimmer dropdown modal nag progress
    popup rating search shape sidebar sticky tab transition video)
    )
  {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/(\.ui)?.$file/x);
    $served_files->{$file . '.min.css'} = 1;
    $t->get_ok($path . $file . '.min.js')->status_is(200)->content_like(qr/function/x);
    $served_files->{$file . '.min.js'} = 1;
  }
};
subtest views => sub {
  my $path = $base;
  for my $file (qw(card comment feed item statistic)) {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/(\.ui)?.$file/x);
    $served_files->{$file . '.min.css'} = 1;
  }
};

subtest themes => sub {
  $base = '/vendor/SemanticUI/themes/';
  my $path = $base . 'basic/assets/fonts/';
  for my $ext (qw(eot svg ttf woff)) {
    $t->get_ok($path . 'icons.' . $ext)->status_is(200);

    # Let default/assets/fonts/ have the keys.
    #$served_files->{'icons.' . $ext} = 1;
  }

  $path = $base . 'default/assets/fonts/';
  for my $ext (qw(eot otf svg ttf woff)) {
    $t->get_ok($path . 'icons.' . $ext)->status_is(200);
    $served_files->{'icons.' . $ext} = 1;
  }

  $path = $base . 'default/assets/images/';
  $t->get_ok($path . 'flags.png')->status_is(200);
  $served_files->{'flags.png'} = 1;
};
$base = '/vendor/SemanticUI/';
subtest packaged => sub {

  my $path = $base;
  for my $f (qw(semantic.min.css semantic.min.js)) {
    $t->get_ok($path . $f)->status_is(200);
  }
  $served_files->{'semantic.min.css'} = $served_files->{'semantic.min.js'} = 1;
};

# To not miss newly added files with next upgrade.
require File::Find;
my $found_files = {};
subtest 'all served files exist' => sub {
  File::Find::find(
    sub {
      return if -d;
      ok(-f $_ && $served_files->{$_}, $_ . ' is served.');

      #do not count basic theme fonts
      return if $File::Find::dir =~ m|basic/assets/fonts|;
      $found_files->{$_} = 1;
    },
    $INC[0] . '/Mojolicious/public/vendor/SemanticUI'
  );
};

is_deeply($found_files, $served_files, 'all found files are served');

done_testing();
