package Hopkins::Plugin::HMI::Catalyst::Controller::Root;

use strict;
use warnings;

=head1 NAME


=head1 DESCRIPTION

=cut

use Sys::Hostname::FQDN 'fqdn';

use base 'Hopkins::Plugin::HMI::Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

=head1 METHODS

=cut

=over 4

=item new

=cut

sub auto : Private
{
	my $self	= shift;
	my $c		= shift;

	$c->stash->{host} = fqdn;
}

sub default : Private
{
	my $self	= shift;
	my $c		= shift;

}

sub login : Local : ActionClass('REST') { }

sub login_GET
{
	my $self	= shift;
	my $c		= shift;

	$c->stash->{template} = 'login.tt';
}

sub end : ActionClass('RenderView') { }

=back

=head1 AUTHOR

Mike Eldridge <diz@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=cut

1;
