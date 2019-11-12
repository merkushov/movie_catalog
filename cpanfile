requires 'DBIx::Class';
requires 'DBD::mysql';
requires 'Test::mysqld';
requires 'Log::Dispatch';
requires 'Term::Size::Any';

requires 'Moose';

requires 'Catalyst';
requires 'Catalyst::Runtime';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Authentication::Realm::SimpleDB';
requires 'Catalyst::Authentication::Credential::Password';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Test::WWW::Mechanize::Catalyst';

requires 'Catalyst::View::TT';
