package Hopkins::Plugin::HMI::Catalyst;

use strict;
use warnings;

=head1 NAME


=head1 DESCRIPTION

=cut

use Catalyst;
use Catalyst::Engine::Embeddable;

use File::ShareDir;

# fuck catalyst and its compile-time bullshit

__PACKAGE__->config(%$Hopkins::Plugin::HMI::catalyst);

use Hopkins::Plugin::HMI::Log;
#use Catalyst::Log::Log4perl;

__PACKAGE__->setup(qw/Authentication Session Session::Store::FastMmap Session::State::Cookie Static::Simple/);
__PACKAGE__->log(new Hopkins::Plugin::HMI::Log);

sub setup_home
{
	my $self = shift;

	$self->next::method(@_);

	my $share = eval { File::ShareDir::dist_dir('Hopkins-Plugin-HMI') . '/root' };
	my $local = Hopkins::Plugin::HMI::Catalyst->path_to('share/root');

	my $root = -d $local ? $local : $share;

	die 'unable to determine template location' if not $root;

	$self->config->{root} = $root;
}

# override Catalyst::Engine::Embeddable to make fixes to the
# engine.  i've attempted to push these fixes upstream, but
# the maintainer won't respond.

{
	package Catalyst::Engine::Embeddable;

	sub prepare_request {
		my ($self, $c, $req, $res_ref, $err_ref) = @_;
		$c->req->{_engine_embeddable}{req} = $req;
		$c->req->{_engine_embeddable}{res} = $res_ref;
		$c->req->{_engine_embeddable}{err} = $err_ref;
		$c->req->method($req->method);
	}

	sub prepare_path {
		my ($self, $c) = @_;

		my $uri = $c->req->{_engine_embeddable}{req}->uri();
		my $base = $uri->clone; $base->path('/'); $base->path_query('');

		$c->req->uri($uri);
		$c->req->base($base);
	}

	sub finalize_error
	{
		my ($self, $c) = @_;

		@{ $c->req->{_engine_embeddable}->{err} } = @{ $c->error };

		$c->res->status(500);
	}
}

=back

=head1 AUTHOR

Mike Eldridge <diz@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=cut

1;
