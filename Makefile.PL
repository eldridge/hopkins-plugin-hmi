#!/usr/bin/perl -w

use warnings;
use strict;

use inc::Module::Install;

name			'Hopkins-Plugin-HMI';
author			'Mike Eldridge <diz@cpan.org>';
license			'perl';
version_from	'lib/Hopkins/Plugin/HMI.pm';

# hopkins
requires 'Hopkins' => '0.900';

# supporting classes
requires 'Class::Accessor::Fast'						=> '0.31';
requires 'POE::Component::Server::HTTP'					=> '0.09';
requires 'Sys::Hostname::FQDN'							=> '0.10';
requires 'File::ShareDir'								=> '1.00';
requires 'Catalyst::Action::RenderView'					=> '0.08';
requires 'Catalyst::Engine::Embeddable'					=> '0.000002';
requires 'Catalyst::Plugin::Authentication'				=> '0.100092';
requires 'Catalyst::Plugin::Session'					=> '0.24';
requires 'Catalyst::Plugin::Session::Store::FastMmap'	=> '0.11';

# required for the test suite
#test_requires 'Class::Accessor::Fast';
#test_requires 'Directory::Scratch';
#test_requires 'FindBin';
#test_requires 'Template';
#test_requires 'Test::MockObject';
#test_requires 'POE::API::Peek';

#auto_install;
install_share;
WriteAll;

