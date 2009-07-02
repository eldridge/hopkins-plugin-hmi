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

	my $hopkins	= $c->config->{hopkins};
	my @tasks	= $hopkins->config->get_task_names;
	my $name	= $c->req->params->{task} || $tasks[0];
	my $task	= $hopkins->config->get_task_info($name);

	if ($c->req->method eq 'POST') {
		my $opts = $c->req->params;
		my $task = delete $opts->{task};

		$hopkins->kernel->post(enqueue => $task => $opts);

		$c->detach('/status');
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
