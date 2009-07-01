package Hopkins::Plugin::HMI::Catalyst::Controller::Task;

use strict;
use warnings;

=head1 NAME

Hopkins::Plugin::HMI::Catalyst::Controller::Task

=head1 DESCRIPTION

=cut

use base 'Hopkins::Plugin::HMI::Catalyst::Controller';

use LWP::UserAgent;

=head1 METHODS

=cut

=over 4

=item enqueue

=cut

sub enqueue : Local
{
	my $self	= shift;
	my $c		= shift;

	my @tasks	= $c->config->{hopkins}->config->get_task_names;
	my $task	= $c->req->params->{task} || $tasks[0];

	if (my $optsrc = $c->config->{optsrc}) {
		my $ua	= new LWP::UserAgent;
		my $uri	= new URI $optsrc;

		$uri->query_form($uri->query_form, task => $task);

		my $res = $ua->get($uri);

		$c->stash->{options}	= $res->content if $res->code == 200;
		$c->stash->{optloaderr}	= 1 if $res->code != 200;
	}

	$c->stash->{task}	= $task;
	$c->stash->{tasks}	= \@tasks;
}

=back

=head1 AUTHOR

Mike Eldridge <diz@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=cut

1;
