package Array::Unique;

use 5.006;
use strict;
use warnings;
use Carp;

our $VERSION = '0.04';

# strips out any duplicate values (leaves in the firts occurance)
# and removes all undef values.
sub unique {
    my $self = shift; # self or class
#    if (ref $_[0] eq 'Array::Unique') {
#	$self = shift;
#	print "#AU\n";
#    }
#    print "# @_\n";
    

    my %seen;
    my @unique = grep defined $_ && !$seen{$_}++ && $_, @_;
    # based on the Cookbook and on suggestion by Jeff 'japhy' Pinyan
}


sub TIEARRAY {
    my $class = shift;
    my $self = {
		array => [],
		hash => {},
		};
    bless $self, $class;
}


sub CLEAR     { 
    my $self = shift;
    $self->{array} = [];
    $self->{hash} = {};
}

sub EXTEND {}

sub STORE {
    my ($self, $index, $value) = @_;
    $self->SPLICE($index, 1, $value);
}



sub FETCHSIZE { 
    my $self = shift;
    return scalar @{$self->{array}};
}

sub FETCH { 
    my ($self, $index) = @_;
    ${$self->{array}}[$index];
}


sub STORESIZE { 
    my $self = shift;
    my $size = shift;

    # We cannot enlarge the array as the values would be undef

    # But we can make it smaller
#   if ($self->FETCHSIZE > $size) {
#	$self->{->Splice($size);
#    }

    $#{$self->{array}} = $size-1;
    return $size;
}

sub SPLICE {
    my $self = shift;
    my $offset = shift;
    my $length = shift;

#=pod
    # reset length value to positive (this is done by the normal splice too)
    if (defined $length and $length < 0) {
	#$length = @{$self->{array}} + $length;
	$length += $self->FETCHSIZE - $offset;
    }

    # reset offset to positive (this is done by the normal splice too)
    if (defined $offset and $offset < 0) {
	$offset += $self->FETCHSIZE;
    }
#=cut

    if (defined $offset and
	$offset > $self->FETCHSIZE) {
	$offset = $self->FETCHSIZE;
        # should give a warning like this: splice() offset past end of array
	# if this was really a splice (and warning set) but no warning if this
	# was an assignment to a high index.
    }

#    my @s = @{$self->{array}}[$offset..$offset+$length]; # the old values to be returned
    my @original;
#    if (defined $length) {
	@original = $self->Splice($self->{array}, $offset, $length, @_);
#    } elsif (defined $offset) {
#	@original = $self->Splice($self->{array}, $offset);
#    } else {
#	@original = $self->Splice($self->{array});
#    }

    return @original;
}



sub PUSH {
    my $self = shift;

    $self->SPLICE($self->FETCHSIZE, 0, @_);
#    while (my $value = shift) {
#	$self->STORE($self->FETCHSIZE+1, $value);
#    }
    return $self->FETCHSIZE;
}

sub POP {
    my $self = shift;
    ($self->SPLICE(-1))[0];
}

sub SHIFT {
    my $self = shift;
#    #($self->{array})[0];
    ($self->SPLICE(0,1))[0];
}

sub UNSHIFT {
    my $self = shift;
    $self->SPLICE(0,0,@_);
}


sub Splice {
    my $self = shift;
    my $a = shift;
    my $offset = shift;
    my $length = shift;

    my @original;
    if (defined $length) {
	@original = splice(@$a, $offset, $length, @_);
    } elsif (defined $offset) {
	@original = splice(@$a, $offset);
    } else {
	@original = splice(@$a);
    }
    @$a = $self->unique(@$a);
    return @original;
}

1;
__END__
=pod

=head1 NAME

Array::Unique - Tieable array that allows only unique values

=head1 SYNOPSIS

 use Array::Unique;
 tie @a, 'Array::Unique';

 Use @a as a regular array.

=head1 DESCRIPTION

This package lets you create an array which will allow
only one occurence of any value.

In other words no matter how many times you put in 42
it will keep only the first occurance and the rest will
be droped.

You use the module via tie and once you tied your array to
this module it will behave correctly.

Uniqueness is checeked with the 'eq' operator so 
among other things it is case sensitive.

The module does not allow undef as a value in the array.

=head1 EXAMPLES

 use Array::Unique;
 tie @a, 'Array::Unique';

 @a = qw(a b c a d e f);
 push @a, qw(x b z);
 print "@a\n";          # a b c d e f x z

=head1 DISCUSSION

 When you are collecting a list of items and you want 
 to make sure there is only one occurence of each item,
 you have several option:


=over 4

=item 1) using an array and extracting the unique elements later

 There is good discussion about it in the Perl Cookbook of O'Reilly.
 I have copied the solutions here, you can see further discussion in the
 book.

 ----------------------------------------
 Extracting Unique Elements from a List (Section 4.6 in the Perl Cookbook 1st ed.)

 # Straightforward

 %seen = ();
 @uniq = ();
 foreach $item (@list) [
     unless ($seen{$item}) {
       # if we get here we have not seen it before
       $seen{$item} = 1;
       push (@uniq, $item);
    }
 } 

 # Faster
 %seen = ();
 foreach $item (@list) {
   push(@uniq, $item) unless $seen{$item}++;
 }

 # Faster but different
 %seen;
 foreach $item (@list) {
   $seen{$item}++;
 }
 @uniq = keys %seen;

 # Faster and even more different
 %seen;
 @uniq = grep {! $seen{$_}++} @list;

 ----------------------------------------

 Anyway, all these solutions

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

=head1 BUGS

 I think you cannot use two different implementations
 in the same script.

=head1 TODO

 Benchmark speed

 Add faster functions that don't check uniqueness so if I 
   know part of the data that comes from a uniques source then
   I can speed up the process,
   In short shoot myself in the leg.

 Enable optional compare with other functions

 Write even better implementations.

=head1 AUTHOR

 Gabor Szabo <gabor@perl.org.il>

 Copyright (C) 2002-2003 Gabor Szabo <gabor@perl.org.il>
 All rights reserved.

 You may distribute under the terms of either the GNU 
 General Public License or the Artistic License, as 
 specified in the Perl README file.

 No WARRANTY whatsoever.

=head1 SUPPORT

 There is no official support for this package but
 you can send bug reports directly to the author.

 To get other support answers you should use either
 the Hungarian Perl mailing list at http://www.perl.org.hu/
 if you want to ask in Hungarian or the Israeli Perl 
 mailing list at http://www.perl.org.il/ in English.

=head1 CREDITS

 Thanks for suggestions and bug reports to 
 Szabo Balazs (dLux)
 Shlomo Yona
 Gaal Yahas
 Jeff 'japhy' Pinyan

=head1 VERSION

 Version: 0.04
 Date:    2003.01.18

=cut
