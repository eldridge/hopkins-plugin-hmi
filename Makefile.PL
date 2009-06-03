#!/usr/bin/perl -w

use warnings;
use strict;

use inc::Module::Install;

name			'Hopkins-Plugin-HMI';
author			'Mike Eldridge <diz@cpan.org>';
license			'perl';
version_from	'lib/Hopkins/Plugin/HMI.pm';

# hopkins
requires 'Hopkins'						=> '0.900';

# supporting classes
requires 'Class::Accessor::Fast'		=> '0.31';
requires 'POE::Component::Server::HTTP'	=> '0.09';
requires 'Sys::Hostname::FQDN'			=> '0.10';
requires 'Catalyst::Engine::Embeddable'	=> '0.000002';

# required for the test suite
#test_requires 'Class::Accessor::Fast';
#test_requires 'Directory::Scratch';
#test_requires 'FindBin';
#test_requires 'Template';
#test_requires 'Test::MockObject';
#test_requires 'POE::API::Peek';

#auto_install;
WriteAll;

