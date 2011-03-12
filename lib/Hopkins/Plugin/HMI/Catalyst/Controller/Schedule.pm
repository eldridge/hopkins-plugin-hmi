package # hide from PAUSE
	Hopkins::Plugin::HMI::Catalyst::Controller::Schedule;

use strict;
use warnings;

=head1 NAME

Hopkins::Plugin::HMI::Catalyst::Controller::Queue

=head1 DESCRIPTION

=cut

use base 'Hopkins::Plugin::HMI::Catalyst::Controller';

use Cairo;

=head1 METHODS

=cut

=over 4

=item halt

=cut

sub default : Private
{
	my $self	= shift;
	my $c		= shift;
	my $name	= shift;

	my $hopkins = $c->config->{hopkins};

	my @tasks = ();

	foreach my $name ($hopkins->config->get_task_names) {
		my $task = $hopkins->config->get_task_info($name);

		next if not defined $task->schedule;
		next if not $task->enabled;

		push @tasks, $task;
		#my $next = $task->schedule->next($now);
	}

	$c->stash->{tasks}		= \@tasks;
	$c->stash->{template}	= 'schedule.tt';
}

sub image : Local
{
	my $self	= shift;
	my $c		= shift;

	my $num_hours	= 12;
	my $begin		= DateTime->now;

	$begin->truncate(to => 'hour');

	my $surface	= Cairo::ImageSurface->create('argb32', 750, 400);
	my $ctx		= Cairo::Context->create($surface);

	$ctx->rectangle(0.5, 0.5, 749, 20);

	foreach my $offset (0 .. $num_hours) {
		my $date = $begin->clone->add(hours => $offset);

		my $w = 749 / $num_hours;

		$ctx->move_to(int($w * $offset) + $w/2, 10);
		$ctx->show_text($date->strftime('%H'));

		$ctx->move_to(int($w * $offset)+0.5, 0);
		$ctx->line_to(int($w * $offset)+0.5, 20);
	}

	$ctx->set_source_rgb(0, 0, 0);
	$ctx->set_line_width(1.0);
	$ctx->stroke;
	$ctx->show_page;

	$c->res->content_type('image/png');
	$c->res->status(200);

	my $data;

	#$surface->write_to_png_stream(sub { $c->res->write($_[1]) });
	$surface->write_to_png_stream(sub { $data .= $_[1] });

	$c->res->body($data);
}

=back

=head1 AUTHOR

Mike Eldridge <diz@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=cut

1;
