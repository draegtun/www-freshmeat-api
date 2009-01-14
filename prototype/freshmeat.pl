#!/usr/local/bin/perl

# second prototype - 12th January 2009

use strict;
use warnings;
use Perl6::Say;

{
    package FreshMeat::Base;
    use Moose::Role;
    
    has 'session'   => ( isa => 'HashRef', is => 'rw', default => sub { +{} } );
    has 'fatal' => ( isa => 'Bool', is => 'rw', default => 1 );
    
    sub dump_session { $_[0]->{session} }
    
    sub sid { $_[0]->session->{ SID } }
    
    sub lifetime { $_[0]->session->{ Lifetime } }
    
    sub api { $_[0]->session->{ 'API Version' } }
    
    no Moose::Role;
}

{
    package FreshMeat::API::XML::RPC;
    use Moose::Role;
    use XML::RPC;
    
    requires 'session';
    
    has 'agent' => ( 
        isa      => 'XML::RPC', 
        is       => 'ro', 
        default  => sub { XML::RPC->new( 'http://freshmeat.net/xmlrpc/' ) },
        handles  => [ qw/call/ ],
        lazy     => 1,
        required => 1,
    );
    
    sub login {
        my ( $self, %params ) = @_;
        $self->session( $self->agent->call( 'login', \%params ) );
    }
        
    sub fetch_project_list {
        my $self = shift;
        $self->agent->call( 'fetch_project_list' );
    }
    
    no Moose::Role;
}

{
    package FreshMeat::API::MockObject;
    use Moose;
    use Data::Dumper;
    
    sub call {
        print "Mockery $_[1]\n";
        return "Mockery $_[1] " . Dumper( $_[2] );
    }
}

{
    package FreshMeatAPIV1_03;
    use base 'Exporter';
    our @EXPORT_OK = qw/get_api_details/;
    
    our $api = {
    
        fetch_available_licenses => {
            desc    => 'Fetch all available licenses',
            params  => [],
            returns => [ qw/Array of available licenses/ ],
        },
            
        fetch_available_release_foci => {
            desc    => 'Fetch all available release focus types',
            params  => [],
            returns => [ qw/Struct of available release focus types and associated IDs/ ],
        },
        
        fetch_branch_list => {
            desc    => 'Fetch all branch names and IDs for a given project', 
            params  => [ qw/SID project_name/ ],
            returns => [ qw/Array of branch name strings./ ],
        },
            
        fetch_project_list => {
            desc    => 'Fetch all projects assigned to logged in user',
            params  => [ qw/SID/ ],
            returns => [ qq{Array of structs consisting of "projectname_full", "projectname_short", "project_status", and "project_version"} ],
        },
            
        fetch_release => {
            desc    => 'Fetch data from a pending release submission',
            params  => [ qw/SID project_name branch_name version/ ],
            returns => [ qq{Struct consisting of "version", "changes", "release_focus", and "hide_from_frontpage"} ],
        },
        
        login => {
            desc    => 'Start an XML-RPC session',
            params  => [ qw/username password/ ],
            returns => [ 'SID', 'Lifetime', 'API Version' ],
        },
        
        logout => {
            desc    => 'End an XML-RPC session',
            params  => [ qw/SID/ ],
            returns => [ qq{Struct of "OK" => "Logout successful." if logout was successful} ],
        },
        
        publish_release	=> {
            desc    => 'Publish a new release',
            params  => [ qw/
                SID project_name branch_name version changes release_focus hide_from_frontpage
                license url_homepage url_tgz url_bz2 url_zip url_changelog url_rpm url_deb 
                url_osx url_bsdport url_purchase url_cvs url_list url_mirror url_demo	   
            / ],
            returns => [ qq{Struct of "OK" => "submission successful"} ],
        },
        
        withdraw_release => {
            desc    => 'Take back a release submission',
            params  => [ qw/SID project_name branch_name version/ ],
            returns => [ qq{Struct of "OK" => "Withdraw successful."} ],
        },
    };
    
    # [ Appendix A: Release focus IDs ]
    # 0 - N/A
    # 1 - Initial freshmeat announcement
    # 2 - Documentation
    # 3 - Code cleanup
    # 4 - Minor feature enhancements
    # 5 - Major feature enhancements
    # 6 - Minor bugfixes
    # 7 - Major bugfixes
    # 8 - Minor security fixes
    # 9 - Major security fixes
    # 
    # 
    # [ Appendix B: Error codes ]
    #  10 - Login incorrect
    #  20 - Session inconsistency
    #  21 - Session invalid
    #  30 - Branch ID incorrect
    #  40 - Permission to publish release denied
    #  50 - Version string missing
    #  51 - Duplicate version string
    #  60 - Changes field empty
    #  61 - Changes field too long
    #  62 - Changes field contains HTML
    #  70 - No valid email address set
    #  80 - Release not found
    #  81 - Project not found
    #  90 - Release focus missing
    #  91 - Release focus invalid
    # 100 - License invalid
    # 999 - Unknown error
    
    sub get_api_info { $api }
    
    1;
    
}

{
    package FreshMeat::API;
    use Moose::Role;
    requires 'session';
    
    use FMdata qw/get_api_info/;

    my %method = (
        login => 'login',
        fetch_project_list => 'fetch_project_list',
    );
    
    sub BUILD {
        my $self = shift;
        for my $name ( keys %{ get_api_info() } ) {
            $self->meta->add_method( $name => sub {
                my ( $self, %params ) = @_;
                $self->session( $self->agent->call( $name, \%params ) );
            });
        }
    }
    
    # sub BUILD {
    #     my $self = shift;
    #     for my $name ( keys %method ) {
    #         $self->meta->add_method( $name => sub {
    #             my ( $self, %params ) = @_;
    #             $self->session( $self->agent->call( $method{ $name }, \%params ) );
    #         });
    #     }
    # }
    
    no Moose::Role;
}

{
    package FreshMeat::API::Mock;
    use Moose::Role;
    requires 'session';
    with 'FreshMeat::API';
    
    has 'agent' => ( 
        isa      => 'Object', 
        is       => 'ro', 
        default  => sub { FreshMeat::API::MockObject->new },
        handles  => [ qw/call/ ],
        lazy     => 1,
        required => 1,
    );
    
    sub loginx {
        my ( $self, %params ) = @_;
        $self->session( $self->agent->call( 'login', \%params ) );
    }
    
}

{
    package FreshMeat;
    use Moose;
    with 'FreshMeat::Base', 'FreshMeat::API::Mock';
    

    no Moose;
}

use Data::Dumper;
my $fm = FreshMeat->new;
$fm->login( username => 'username', password => 'pass1' );
say Dumper( $fm );

$fm->publish_release;
#say $fm->sid;
#say Dumper( $fm->fetch_project_list );


__END__

use Data::Dumper;

{
    package FreshMeat::Agent::XML::RPC;
    use Moose;
    use XML::RPC;

    has '_url' => ( isa => 'Str', is => 'ro', default => 'http://freshmeat.net/xmlrpc/' );
    
    has '_agent' => ( 
        isa      => 'XML::RPC', 
        is       => 'ro', 
        default  => sub { XML::RPC->new( $_[0]->{_url} ) },
        handles  => [ qw/call/ ],
        lazy     => 1,
        required => 1,
    );

    no Moose;
}

{
    package FreshMeat;
    use Moose;
    use Data::Dumper;
    
    has 'session'   => ( isa => 'Str', is => 'rw', default => '' );
    has 'fatal' => ( isa => 'Bool', is => 'rw', default => 1 );
    has 'agent' => ( 
        isa     => 'Object',  
        is      => 'ro', 
        default => sub { FreshMeat::Agent::XML::RPC->new },
    );
    
    sub login {
        my ( $self, %params ) = @_;
        $self->session( $self->agent->call( 'login', \%params ) );
        print Dumper( $self->{session} );
    }
    
    sub sid { $_[0]->session->{SID} }
    
    no Moose;
}

my $fm = FreshMeat->new;
$fm->login( username => 'username', password => 'pass1' );
say $fm->sid;




__END__


my $fm = FreshMeat->new( fatal => 1, agent => FreshMeat::Agent::XML::RPC->new( 'http://freshmeat.net/xmlrpc/', api_version => 1 ) );

$fm->login( username => 'username', password => 'pass1' );

$fm->login( profile => '.freshmeat' );

$fm->login( use_netrc => 1 );

say $fm->sid;   # SID
say $fm->lifetime;   # in secs  Lifetime
say $fm->epoch;
say $fm->expire;
say $fm->time_left;  # in secs
say $fm->api;  # API Version

$fm->fetch_project_list;   # have login automatically do this?
$fm->get_projects;         # so can do this.. returns array of hashes



__END__

# initial prototype - 8th January 2008

my $fm = XML::RPC->new( 'http://freshmeat.net/xmlrpc/' );

my $session = $fm->call( 'login', { username => 'username', password => 'pass1x2' });

say Dumper( $session );

my $x = $fm->call( 'fetch_project_list', { SID => $session->{SID} } );

say $x;
say Dumper( $x );

__END__

HASH(0x196963c)
$VAR1 = {
          'SID' => 'cb351295f663432d194fc865f9393b4c',
          'Lifetime' => '600',
          'API Version' => '1.03'
        };
        
        
        
Login failure
$VAR1 = {
          'faultString' => 'Login incorrect',
          'faultCode' => '10'
        };
