package HTTP::Exception;

use strict;
use HTTP::Exception::Loader;
use HTTP::Status;
use Scalar::Util qw(blessed);

=head1 NAME

HTTP::Exception - throw HTTP-Errors as (Exception::Class-) Exceptions

=head1 VERSION

Version 0.01000

=cut

our $VERSION = '0.01000';
$VERSION = eval $VERSION; # numify for warning-free dev releases

# act as a kind of factory here
sub new  {
    my $class       = shift;
    my $error_code  = shift;

    die ('HTTP::Exception->throw needs a HTTP-Statuscode to throw')  unless ($error_code);
    die ("Unknown HTTP-Statuscode: $error_code") unless (HTTP::Status::status_message ($error_code));

    "HTTP::Exception::$error_code"->new(@_);
}

# makes HTTP::Exception->caught possible instead of HTTP::Exception::Base->caught
sub caught {
    my $self = shift;
    my $e = $@;
    return $e if (blessed $e && $e->isa('HTTP::Exception::Base'));
    $self->SUPER::caught(@_);
}

1;

=head1 SYNOPSIS

HTTP::Exception lets you throw HTTP-Errors as Exceptions.

    use HTTP::Exception;

    # throw a 404 Exception
    HTTP::Exception->throw(404);

    # later in your framework
    eval { ... };
    if (my $e = HTTP::Exception->caught) {
        # do some errorhandling stuff
        print $e->code;             # 404
        print $e->status_message;   # Not Found
    }

You can also throw HTTP::Exception-subclasses like this.

    # same 404 Exception
    eval { HTTP::Exception::404->throw(); };
    eval { HTTP::Exception::NOT_FOUND->throw(); };

And catch them accordingly.

    # same 404 Exception
    eval { HTTP::Exception::404->throw(); };

    if (my $e = HTTP::Exception::405->caught)       { do stuff } # won't catch
    if (my $e = HTTP::Exception::404->caught)       { do stuff } # will catch
    if (my $e = HTTP::Exception::NOT_FOUND->caught) { do stuff } # will catch
    if (my $e = HTTP::Exception->caught)            { do stuff } # will catch every HTTP::Exception
    if (my $e = Exception::Class->caught)           { do stuff } # catch'em all

You can create Exceptions and not throw them (don't know what that could be
usefull for, except testing).

    # is not thrown, ie doesn't die, only created
    my $e = HTTP::Exception->new(404);
    # usual stuff works
    $e->code;               # 404
    $e->status_message      # Not Found

=head1 DESCRIPTION

Every HTTP::Exception is a L<Exception::Class> - Class. So the same mechanisms
apply as with L<Exception::Class>-classes. In fact have a look at
L<Exception::Class>' docs for more general information on exceptions and
L<Exception::Class::Base> for information on what methods a caught exception
also has.

HTTP::Exception is only a factory for HTTP::Exception::XXX (where X is a number)
subclasses. That means that HTTP::Exception->new(404) returns a
HTTP::Exception::404 object, which in turn is a HTTP::Exception::Base - Object.

Don't bother checking a caught HTTP::Exception::...-class with "isa" as it might
not contain what you would expect. Use the code- or status_message-attributes
and the is_ -methods instead.

The subclasses are created at compile-time, ie the first time you make
"use HTTP::Exception". See paragraph below for the naming scheme of those
subclasses.

Subclassing the subclasses works as expected.

=head1 NAMING SCHEME

=head2 HTTP::Exception::XXX

X is a Number and XXX is a valid HTTP-Statuscode

=head2 HTTP::Exception::STATUS_MESSAGE

STATUS_MESSAGE is the same name as a L<HTTP::Status> Constant B<WITHOUT>
the HTTP_ at the beginning. So see L<HTTP::Status/"Constants"> for more details.

=head1 ACCESSORS

=head2 code Readonly

The HTTP-Statuscode

=head2 status_message

The HTTP-Statusmessage as provided by L<HTTP::Status>

=head2 is_info

Return TRUE if C<$code> is an I<Informational> status code (1xx).  This
class of status code indicates a provisional response which can't have
any content.

=head2 is_success

Return TRUE if C<$code> is a I<Successful> status code (2xx).

=head2 is_redirect

Return TRUE if C<$code> is a I<Redirection> status code (3xx). This class of
status code indicates that further action needs to be taken by the
user agent in order to fulfill the request.

=head2 is_error

Return TRUE if C<$code> is an I<Error> status code (4xx or 5xx).  The function
return TRUE for both client error or a server error status codes.

=head2 is_client_error

Return TRUE if C<$code> is an I<Client Error> status code (4xx). This class
of status code is intended for cases in which the client seems to have erred.

=head2 is_server_error

Return TRUE if C<$code> is an I<Server Error> status code (5xx). This class
of status codes is intended for cases in which the server is aware
that it has erred or is incapable of performing the request.

POD for is_ methods is Copy/Pasted from L<HTTP::Status>, so check back there and
alert me of changes.

=head1 PLACK

HTTP::Exception can be used with L<Plack::Middleware::HTTPExceptions>. But
HTTP::Exception does not depend on L<Plack>, you can use it anywhere else. It
just plays nicely with L<Plack>.

=head1 COMPLETENESS

For the sake of completeness, HTTP::Exception provides exceptions for
non-error-http-statuscodes. This means you can do

    HTTP::Exception->throw(200);

which throws an Exception of type OK. Maybe useless, but complete.

=head1 CAVEATS

The HTTP::Exception-Subclass-Creation relies on L<HTTP::Status>.
It's possible that the Subclasses change, when HTTP::Status'
constants are changed.

New Subclasses are created automatically, when constants are added to
HTTP::Status. That means in turn, that Subclasses disappear, when constants
are removed from L<HTTP::Status>.

The Changes-File of L<HTTP::Status> indicates, that the last change to its
constants was made in 2008. I think, that breaking changes are quite unlikely.

=head1 AUTHOR

Thomas Mueller, C<< <thomas.mi.iller at gmail.com> >>

=head1 SEE ALSO

=head2 L<Exception::Class>, L<Exception::Class::Base>

Consult Exception::Class' documentation for the Exception-Mechanism and
Exception::Class::Base' docs for a list of methods our caught Exception is also
capable of.

=head2 L<HTTP::Status>

Constants, Statuscodes and Statusmessages

=head2 L<Plack>, especially L<Plack::Middleware::HTTPExceptions>

Have a look at Plack, because it rules in general. In the first place, this
Module was written as the counterpart for L<Plack::Middleware::HTTPExceptions>,
but since it doesn't depend on Plack, you can use it anywhere else, too.

=head1 BUGS

Please report any bugs or feature requests to
C<bug-http-exception at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTTP-Exception>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTTP::Exception

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