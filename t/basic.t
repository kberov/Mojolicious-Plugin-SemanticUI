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

our $base = '/vendor/SemanticUI/definitions/';

subtest 'behaviors' => sub {
  my $path = $base . 'behaviors/';
    for my $file (qw(api colorize form state visibility visit)) {
    $t->get_ok($path . $file . '.min.js')->status_is(200)->content_like(qr/function/x);
  }
};
subtest collections => sub {
  my $path = $base . 'collections/';
  for my $file (qw(breadcrumb form grid menu message table)) {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/\.ui\.$file/x);
  }
};
subtest elements => sub {
  my $path = $base . 'elements/';
  for my $file (
    qw(button divider flag header icon image input label list
    loader progress reveal segment step)
    )
  {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/(\.ui\.)?$file/x);
  }
};
subtest globals => sub {
  my $path = $base . 'globals/';
  for my $file (qw(reset site)) {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/semantic-ui/x);
  }
  $t->get_ok($path . 'site.min.js')->status_is(200)->content_like(qr/function/x);
};
subtest modules => sub {
  my $path = $base . 'modules/';
  for my $file (
    qw(accordion chatroom checkbox dimmer dropdown modal nag
    popup rating search shape sidebar sticky tab transition video)
    )
  {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/\.ui\.$file/x);
    $t->get_ok($path . $file . '.min.js')->status_is(200)->content_like(qr/function/x);
  }
};
subtest views => sub {
  my $path = $base . 'views/';
  for my $file (qw(card comment feed item statistic)) {
    $t->get_ok($path . $file . '.min.css')->status_is(200)
      ->content_like(qr/(\.ui\.)?$file/x);
  }
};

subtest themes => sub {
  $base = '/vendor/SemanticUI/themes/packages/';
  my $path = $base . 'basic/assets/fonts/';
  for my $ext (qw(eot svg ttf woff)) {
    $t->get_ok($path . 'icons.' . $ext)->status_is(200);
  }

  $path = $base . 'default/assets/fonts/';
  for my $ext (qw(eot otf svg ttf woff)) {
    $t->get_ok($path . 'icons.' . $ext)->status_is(200);
  }

  $path = $base . 'default/assets/images/';
  for my $f (
    qw(large-inverted large medium-inverted medium
    mini-inverted mini small-inverted small)
    )
  {
    $t->get_ok($path . 'loader-' . $f . '.gif')->status_is(200);
  }
};
$base = '/vendor/SemanticUI/definitions/';
subtest packaged => sub {

  my $path = $base . '';
  for my $f (qw(css/semantic.min.css javascript/semantic.min.js)) {
    $t->get_ok($path . $f)->status_is(200);
  }
};

done_testing();
