package Log::ger::Layout::Pattern::Multiline;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Log::ger::Layout::Pattern ();

sub _layout {
    my $format = shift;
    my $msg = shift;
    #my ($init_args, $lnum, $level) = @_;

    join(
        "\n",
        map {
            Log::ger::Layout::Pattern::_layout($format, $_, @_)
          }
            split(/\R/, $msg)
        );
}

sub get_hooks {
    my %conf = @_;

    $conf{format} or die "Please specify format";

    return {
        create_layouter => [
            __PACKAGE__, 50,
            sub {
                [sub { _layout($conf{format}, @_) }];
            }],
    };
}

1;
# ABSTRACT: Pattern layout (with multiline message split)

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Log::ger::Layout 'Pattern::Multiline', format => '%d (%F:%L)> %m';
 use Log::ger;


=head1 DESCRIPTION

This is just like L<Log::ger::Layout::Pattern> except that multiline log message
is split per-line so that a message like C<"line1\nline2\nline3"> (with C<<
"[%r] %m" >> format) is not laid out not as:

 [0.003] line1
 line2
 line3

but as:

 [0.003] line1
 [0.003] line2
 [0.003] line3


=head1 SEE ALSO

L<Log::ger::Layout::Pattern>

Modelled after L<Log::Log4perl::Layout::PatternLayout::Multiline>.
