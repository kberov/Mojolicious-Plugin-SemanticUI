package Mojolicious::Plugin::SemanticUI;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Util qw(class_to_path);
use List::Util qw(first);
use File::Spec::Functions qw(catdir);

our $VERSION = '0.06';

sub register {
  my ($self, $app) = @_;
  $self->_add_paths($app);
  return;
}

# Add Plugin specific paths in case they differ from $app paths.
sub _add_paths {
  my ($self, $app) = @_;
  my $class_path = $INC{class_to_path(__PACKAGE__)};
  $class_path =~ s|Mojolicious[\\/].*$||x;
  my ($static, $templates) = (
    catdir($class_path, 'Mojolicious', 'public'),
    catdir($class_path, 'Mojolicious', 'templates')
  );

  if (!(first { $static eq $_ // '' } @{$app->static->paths})
    && (-d $static))
  {
    push @{$app->static->paths}, $static;
  }

  if (!(first { $templates eq $_ // '' } @{$app->renderer->paths})
    && (-d $templates))
  {
    push @{$app->renderer->paths}, $templates;
  }

  return;
}

1;

__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::SemanticUI - Semantic UI for your application

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('SemanticUI');

  # Mojolicious::Lite
  plugin 'SemanticUI';

  #in your layout (or template)
  <head>
  <!-- ... -->
  %= stylesheet begin
    @import url('/vendor/SemanticUI/definitions/elements/button.min.css');
    @import url('/vendor/SemanticUI/definitions/elements/divider.min.css');
  %=end
  %= javascript '/vendor/SemanticUI/definitions/javascript/semantic.min.js'
  <!-- ... -->
  </head>

=head1 DESCRIPTION

L<Mojolicious::Plugin::SemanticUI> 
includes the minifed build of the Semantic UI CSS and Javascript library.
Note that the beta 1.0 version is included - L<http://beta.semantic-ui.com/>.
It also provides helpers (TODO) for using Semantic UI modules
in your templates.
This way you do not need to download Semantic UI separately.
This is ALPHA release - B<not ready for production>.

=head1 METHODS

L<Mojolicious::Plugin::SemanticUI> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 HELPERS

L<Mojolicious::Plugin::SemanticUI> exports the following
helpers for use in controllers and templates.
The helpers are provided in the C<SemanticUI> namespace.

  % my $sui = $c->SemanticUI;
  %= $sui->segment begin
    Ала-бала-ница, турска паница,
    Хей гиди Ванчо,
    наш капитанчо...
  %=end

=head2 segment

TODO
...

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<Ado>,
L<http://beta.semantic-ui.com/>, L<http://mojolicio.us>.

=head1 AUTHOR

Красимир Беров (Krasimir Berov)

=head1 COPYRIGHT AND LICENSE

Copyright 2014 Красимир Беров (Krasimir Berov).

This program is free software, you can redistribute it and/or
modify it under the terms of the
GNU Lesser General Public License v3 (LGPL-3.0).
You may copy, distribute and modify the software provided that
modifications are open source. However, software that includes
the license may release under a different license.

See http://opensource.org/licenses/lgpl-3.0.html for more information.

=cut
