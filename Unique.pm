package Array::Unique;

use 5.006;
use strict;
#use warnings;

our $VERSION = '0.01';

use Tie::Array;
use base qw(Tie::StdArray);

#sub TIEARRAY  { bless [], $_[0] }
#sub FETCHSIZE { scalar @{$_[0]} }
#sub STORESIZE { $#{$_[0]} = $_[1]-1 }
#####sub STORE     { $_[0]->[$_[1]] = $_[2] }
#sub FETCH     { $_[0]->[$_[1]] }
#sub CLEAR     { @{$_[0]} = () }
#sub POP       { pop(@{$_[0]}) }
#####sub PUSH      { my $o = shift; push(@$o,@_) }
#sub SHIFT     { shift(@{$_[0]}) }
#sub UNSHIFT   { my $o = shift; unshift(@$o,@_) }
#sub EXISTS    { exists $_[0]->[$_[1]] }
#sub DELETE    { delete $_[0]->[$_[1]] }
#sub SPLICE
#sub EXTEND
#sub DESTROY

sub clean {
    my $self = shift;

#    print "DEBUG: '@$self'\n";
    #print "DEBUG2: '@$self'\n";
    my @temp;
    foreach my $v (@$self) {
	next unless (defined $v);
	unless (grep {$v eq $_} @temp) {
	    push @temp, $v;
	}
    }
    @$self = @temp;

}


sub STORE {
    my $self = shift;
#    print "STORE PARAM: @_\n";

    $self->SUPER::STORE(@_);

    $self->clean;

#    my $index = shift;
#    my $value = shift;

#    print "STORE: @$self\n";
#    unless (scalar grep {$value eq $_} @$self) {
#	$self->[$index]=$value;
#    }
#    foreach my $v (@$self) {
#	return if ($v eq $value);
#    }
#    $self->[$index]=$value;
}

sub PUSH {
    my $self = shift;

    $self->SUPER::PUSH(@_);
    $self->clean;

#    $self->STORE($self->FETCHSIZE, shift) while (@_);
}


sub UNSHIFT {
    my $self = shift;

    $self->SUPER::UNSHIFT(@_);
    $self->clean;

}

sub SPlICE {
    my $self = shift;

    $self->SUPER::SPlICE(@_);
    $self->clean;
}


1;
__END__

=head1 NAME

Array::Unique - Arrays that allow only unique values

=head1 SYNOPSIS

 use Array::Unique;
 tie @a, Array::Unique;

 Use @a as a regular arrray.

=head1 DESCRIPTION

 There is not much to say here.
 The module provides you with a tie-able array
 that allows only unique values.
 It does not allow undef as a value in the array.

=head1 DISCUSSION

 When you are collecting a list of items and you want 
 to make sure there is only one occurence of each item,
 you have several option:

=over 4

=item 1) using hash

 Some people use the keys of a hash to keep the items and
 put an arbitrary value as the values of the hash:

 To build such a list:
 %unique = map { $_ => 1 } qw( one two one two three four! );

 To print it:
 print join ", ", sort keys %unique;

 To add values to it:
 %unique = map { $_ => 1 }
        (keys %unique, qw( one after the nine oh nine ));

 To remove values:
 delete @unique{ qw(oh nine) };

 To check if a value is there:
 $unique{ $value };        # which is why I like to use "1" as my value

 (thanks to Gaal Yahas for the above explanation)

 There are three drawbacks I see:
 1) You type more.
 2) Your reader might not understand at first why did you use hash 
    and what will be the values.
 3) You lose the order.

 Usually non of them is critical but when I saw this the 10th time
 in a code I had to understand with 0 documentation I got frustrated.

=item 2) using array

 Other people might use real arrays and on each update or
 before they want to use the uniqueness feature of the array
 they might run a function they call @a = unique_value(@);

 This is also good but you have to implement the unique_value
 function AND you have to make sure you don't forget to call it.
 Something I have a tendency to do just before code release.

=item 3) using Array::Unique

 So I decided to write this module because I got frustrated
 by my lack of understanding what's going on in that code
 I mentioned.
 In addition I thought it can a good game to write this and
 then benchmark it.
 Additionally it is nice to have your name displayed in 
 bright lights all over CPAN ... or at least in a module.

 Array::Unique lets you tie an array to hmmm, itself (?)
 and makes sure the values of the array are always unique.

=back

=head1 TODO

 Benchmark speed

 Add faster functions that don't check uniqueness so if I 
   know part of the data that comes from a uniques source then
   I can speed up the process,
   In short shoot myself in the leg.

 Enable optional compare with other functions

 Setup other implementations

=head1 AUTHOR

 Gabor Szabo <gabor@perl.org.il>

=head1 COPYRIGHT AND LICENCE

 Copyright (C) 2002 Gabor Szabo <gabor@perl.org.il>
 All rights reserved.


 You may distribute under the terms of either the GNU 
 General Public License or the Artistic License, as 
 specified in the Perl README file.

 No WARRANTY whatsoever.

=cut
