package Hopkins::Plugin::HMI::Catalyst;

use strict;
use warnings;

=head1 NAME


=head1 DESCRIPTION

=cut

use Catalyst;

# fuck catalyst and its compile-time bullshit

__PACKAGE__->config(%$Hopkins::Plugin::HMI::catalyst);

use Hopkins::Plugin::HMI::Log;
#use Catalyst::Log::Log4perl;

__PACKAGE__->setup(qw/Authentication Session Session::Store::FastMmap Session::State::Cookie Static::Simple/);
__PACKAGE__->log(new Hopkins::Plugin::HMI::Log);

=back

=head1 AUTHOR

Mike Eldridge <diz@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=cut

1;
