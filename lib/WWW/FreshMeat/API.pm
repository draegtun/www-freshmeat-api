package WWW::FreshMeat::API;
use Moose;

our $VERSION = '0.01';

has 'mock' => ( isa => 'Bool', is => 'ro', default => sub { 0 } );

with 'WWW::FreshMeat::API::Session', 
     'WWW::FreshMeat::API::Agent::XML::RPC',
     'WWW::FreshMeat::API::Pub';

no Moose;

1;


__END__


=head1 NAME

WWW::FreshMeat::API - inspect & update your projects on freshmeat.net

=head1 VERSION

Version 0.01


=head1 SYNOPSIS

    use WWW::FreshMeat::API;
    
    my $fm = WWW::FreshMeat::API->new;
    
    $fm->login( username => 'user', password => 'pass' );
    
    say "Your ID for this API session (SID) is ", $fm->sid;

    for my $proj ( @{ $fm->fetch_project_list } ) {
        say "Project      ", $proj->{ projectname_full }; 
        say "- short name ", $proj->{ projectname_short };
        say "- status"    ", $proj->{ project_status };
        say "- version    ", $proj->{ project_version };
    }


=head1 DESCRIPTION

FreshMeat (http://freshmeat.net) provides a very simple XML-RPC API which allows a user to inspect what projects
the user as uploaded and also provides an update & withdrawal mechanism of the users projects.

Requirements....

    1) Must have a FreshMeat login & password

    2) Must have already loaded project onto http://freshmeat.net

For now see ./examples/freshmeat-submit.pl.

More details to follow.


=head1 EXPORT

None

=head1 METHODS

For session methods see L<WWW::FreshMeat::API::Session>

For Freshmeats public API which are mapped to methods see L<WWW::FreshMeat::API::Pub> & L<WWW::FreshMeat::API::Pub::V1_03>

=head2 mock

Testing method.   Not sure this will survive alpha so ignore for now!


=head1 AUTHOR

Barry Walsh, C<< <draegtun at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-freshmeat-api at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-FreshMeat-API>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::FreshMeat::API


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-FreshMeat-API>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-FreshMeat-API>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-FreshMeat-API>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-FreshMeat-API/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 SEE ALSO


=head2 Builder Source Code

GitHub at  http://github.com/draegtun/www-freshmeat-api/tree/master


=head1 DISCLAIMER

This is alpha software.   It does not contain necessary tests & checks yet ;-( 
    
However FreshMeat API is very simple & WWW::FreshMeat::API does work for me. 

I hope to make it beta status very shortly!


=head1 COPYRIGHT & LICENSE

Copyright 2009 Barry Walsh (Draegtun Systems Ltd), all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

