package HTTP::Exception::Loader;

use strict;
use HTTP::Exception::Base;
use HTTP::Status;

=head1 NAME

HTTP::Exception::Loader - Creates HTTP::Exception subclasses

=head1 VERSION

Version 0.01001

=cut

our $VERSION = '0.01001';
$VERSION = eval $VERSION; # numify for warning-free dev releases

################################################################################
# little bit messy, but solid
# - first create packages for Exception::Class, so it can create them on its own
# - then extend those packages by putting methods into the same namespace
sub _make_exceptions {
    my (@http_statuses, @exception_classes);
    {
        no strict 'refs';
        @http_statuses = grep { /^HTTP_/ } (keys %{"HTTP::Status::"});
    }

    my $code = '';
    for my $http_status (@http_statuses) {
        my $statuscode              = HTTP::Status->$http_status;
        my $http_status_message     = HTTP::Status::status_message($statuscode);

        $http_status                =~ s/^HTTP_//;  # remove HTTP_ for exception classname
        my $package_name_code       = 'HTTP::Exception::'.$statuscode;
        my $package_name_message    = 'HTTP::Exception::'.$http_status;

        # create a Package like HTTP::Exception::404,
        # but also a Package HTTP::Exception::NOT_FOUND,
        # which inherits from HTTP::Exception::404
        push @exception_classes,
            $package_name_code      => {isa => 'HTTP::Exception::Base'},
            $package_name_message   => {isa => $package_name_code};

        # built them in while we're at it
        my $is_info         = !!HTTP::Status::is_info         ($statuscode);
        my $is_success      = !!HTTP::Status::is_success      ($statuscode);
        my $is_redirect     = !!HTTP::Status::is_redirect     ($statuscode);
        my $is_error        = !!HTTP::Status::is_error        ($statuscode);
        my $is_client_error = !!HTTP::Status::is_client_error ($statuscode);
        my $is_server_error = !!HTTP::Status::is_server_error ($statuscode);

        # should be quite fast, once loaded
        # is_ -subs are an optimization for speed
        # TODO check whether evaled subs with a ()-prototype are compiled to constants
        $code .= qq~;

            package $package_name_code;
            sub code            () { $statuscode }
            sub _status_message () { '$http_status_message' }

            sub is_info         () { '$is_info'           }
            sub is_success      () { '$is_success'        }
            sub is_redirect     () { '$is_redirect'       }
            sub is_error        () { '$is_error'          }
            sub is_client_error () { '$is_client_error'   }
            sub is_server_error () { '$is_server_error'   }

            package $package_name_message;
            use Scalar::Util qw(blessed);
            sub caught {
                my \$self = shift;
                my \$e = \$@;
                return \$e if (blessed \$e && \$e->isa('$package_name_code'));
                \$self->SUPER::caught(\@_);
            }

        ~;
    }

    eval $code;
    return @exception_classes
}

use Exception::Class ( 'HTTP::Exception' => { isa => 'HTTP::Exception::Base' }, _make_exceptions() );

1;


=head1 DESCRIPTION

This Class Creates all HTTP::Exception subclasses.

DON'T USE THIS PACKAGE DIRECTLY. 'use HTTP::Exception' does this for you.
This Package does its job as soon as you call 'use HTTP::Exception'.

Please refer to the Documentation of HTTP::Exception. The Naming Scheme of all
subclasses created, as well as the caveats can be found there.

This Package calculates the Subclasses' Accessors at compiletime.

=head1 AUTHOR

Thomas Mueller, C<< <thomas.mi.iller at gmail.com> >>

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