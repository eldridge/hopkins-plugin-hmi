package Hopkins::Plugin::HMI;

use strict;
use warnings;

our $VERSION = '0.900';

=head1 NAME

Hopkins::Plugin::HMI - hopkins HMI session (using HTTP)

=head1 DESCRIPTION

Hopkins::Plugin::HMI encapsulates the HMI (human machine
interface) POE session created by the manager session.  this
session uses the Server::HTTP component to provide a web
interface to the job server using Catalyst.

=cut

BEGIN { $ENV{CATALYST_ENGINE} = 'Embeddable' }

use POE;
use POE::Component::Server::HTTP;

use Class::Accessor::Fast;

use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw(kernel manager config app));

our $catalyst;

=head1 STATES

=over 4

=item new

=cut

sub new
{
	my $self = shift->SUPER::new(@_);

	# load the Catalyst-related bits as late as possible so
	# that we can give it a dynamic configuration.  Catalyst
	# is not very OO minded, so we have to monkey around
	# with its worldview.

	$catalyst->{'Plugin::Authentication'}	= $self->config->{auth};
	$catalyst->{session}					= $self->config->{session};

	require 'Hopkins/Plugin/HMI/Catalyst.pm';

	$self->app(new Hopkins::Plugin::HMI::Catalyst);

	# handle plugin-specific configuration, then create
	# a POE::Component::Server::HTTP instance that will
	# dispatch incoming requests to the Catalyst instance.

	$self->config->{port} ||= 8088;

	my %args =
	(
		Port			=> $self->config->{port},
		ContentHandler	=> { '/' => sub { $self->handler(@_) } },
		Headers			=> { Server => "hopkins/$Hopkins::VERSION" }
	);

	new POE::Component::Server::HTTP %args;
}

sub handler
{
	my $self	= shift;
	my $req		= shift;
	my $res		= shift;
	my $app		= $self->app;

	my $obj;

	$app->handle_request($req, \$obj);

	if (ref($obj->content) eq 'IO::File') {
		my $content;

		while (not eof $obj->content) {
			read $obj->content, my ($buf), 64 * 1024;
			$content .= $buf;
		}

		$obj->content($content);
	}

	$res->code($obj->code);
	$res->content($obj->content);
	$res->message('');

	return RC_OK;
}

=back

=head1 AUTHOR

Mike Eldridge <diz@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=cut

1;
