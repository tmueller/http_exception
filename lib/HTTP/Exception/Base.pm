package HTTP::Exception::Base;

use strict;
use parent qw(Exception::Class::Base);

our $VERSION = '0.01000';
$VERSION = eval $VERSION; # numify for warning-free dev releases

sub as_string       { $_[0]->status_message                             }
sub status_message  { $_[0]->{status_message} || $_[0]->_status_message }

sub Fields { return qw~status_message~ }

1;


=head1 NAME

HTTP::Exception::Base - Base class for exception classes created by HTTP::Exception

=head1 DESCRIPTION

This Class is a Base class for exception classes created by HTTP::Exception.
It inherits from Exception::Class::Base. Please refer to the Documentation
of Exception::Class::Base.

You won't use this Class directly, so refer to the Documentation of
HTTP::Exception. The methods and attributes this Class provides over
Exception::Class::Base are described there.

=head1 AUTHOR

Thomas Mueller, C<< <tmueller at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-http-exception at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTTP-Exception>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTTP::Exception::Base

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTTP-Exception>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/HTTP-Exception>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/HTTP-Exception>

=item * Search CPAN

L<http://search.cpan.org/dist/HTTP-Exception/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Thomas Mueller.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut