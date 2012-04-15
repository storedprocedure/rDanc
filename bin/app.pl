#!/usr/bin/env perl
use Dancer;
use WebDev::rdanc;
use File::Slurp;


get '/' => sub {
	debug "app.pl: doing get (/).";
	#return 'Hello World!';
	my $db = connect_db();
	my $sql = 'select id, title, text from entries order by id desc';
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute or die $sth->errstr;
	template 'show_ent.tt', { 
		'msg' => get_flash(),
		'add_entry_url' => uri_for('/add'),
		'entries' => $sth->fetchall_hashref('id'),
	};
};

post '/add' => sub {
	if ( not session('logged_in') ) {
		send_error("Not logged in", 401);
	}
	
	my $db = connect_db();
	my $sql = 'insert into entries (title, text) values (?, ?)';
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute(params->{'title'}, params->{'text'}) or die $sth->errstr;
	
	set_flash('New entry posted!');
	redirect '/';
};




#start;
dance;
