package Array::Unique::Std;

use strict;
#use warnings;

use Tie::Array;
#use base qw(Tie::StdArray);
our @ISA;
push @ISA, qw(Tie::StdArray);

sub _init {
    my $self = shift;
}

sub clean {
    my $self = shift;

#    print "DEBUG: '@$self'\n";
    my @temp;
    foreach my $v (@$self) {
	next unless (defined $v);
	unless (grep {$v eq $_} @temp) {
	    push @temp, $v;
	}
    }
    @$self = @temp;

}
sub STORESIZE {
    my $self = shift;
    my $size = shift;

    if ($self->FETCHSIZE > $size) {
	$self->SUPER::STORESIZE($size);
    }
}

sub STORE {
    my $self = shift;
#    print "STORE PARAM: @_\n";

    $self->SUPER::STORE(@_);

    $self->clean;

}

sub PUSH {
    my $self = shift;

    $self->SUPER::PUSH(@_);
    $self->clean;
}


sub UNSHIFT {
    my $self = shift;

    $self->SUPER::UNSHIFT(@_);
    $self->clean;

}

sub SPLICE {
    my $self = shift;

    my @splice = $self->SUPER::SPLICE(@_);
    $self->clean;
    return @splice;
}

1;
__END__
=pod

See documentation in Array::Unique

=cut
