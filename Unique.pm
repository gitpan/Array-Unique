package Array::Unique;

use 5.006;
use strict;
#use warnings;
use Carp;

our $VERSION = '0.03';

sub TIEARRAY  { 
    my $class = shift;
    my $mode = shift;


    my $self;

    $mode = 'Std' unless (defined $mode);
    
    if ($mode eq "IxHash") {
	$self = bless [], $class;

	require Array::Unique::IxHash;
 	our @ISA;
	#unshift @ISA, "Array::Unique::IxHash";
	@ISA = ("Array::Unique::IxHash");
	#print "DEBUG: @ISA\n";
	# using unshift instead of shift because I had problems
	# with the test code that the previous ISA was not cleaned
	# so I used the same mode for all the test.
	# This is an open issue what to do with the @ISA so only
	# the current instance of the module should get it and not
	# the futuer instances.
    }
    
    if ($mode eq 'Std') {
	$self = bless [], $class;

	require Array::Unique::Std;
 	our @ISA;
	#unshift @ISA, "Array::Unique::Std";
	@ISA = ("Array::Unique::Std");
	#print "DEBUG: @ISA\n";
    }

#    if ($mode eq 'Quick') {
#	$self = bless {}, $class;
#	require Array::Unique::Quick;
# 	our @ISA;
#	@ISA = ("Array::Unique::Quick");
#    }


    if (defined $self) {
	$self->_init;
	return $self;
    } else {
	carp("Invalid mode: '$mode'");
	return undef;
    }
}

1;
__END__
=pod

=head1 NAME

Array::Unique - Tieable array that allows only unique values

=head1 SYNOPSIS

 use Array::Unique;
 tie @a, Array::Unique;
 or
 tie @a, Array::Unique, 'Std';
 or
 tie @a, Array::Unique, 'IxHash';

 Use @a as a regular arrray.

=head1 DESCRIPTION

 This package supplies two different implementation of
 the Unique Array tie construct.

 In both cases you tie a regular array to this class and
 use your array as you did earlier but now if try to add
 a value to the array in any way ($a[3]='s'; or push or 
 unshift or splice) which value was already an element 
 of the array the array will discard one of the copies.

 By this you have an array where the values are unique.

 Uniqueness is checeked with the 'eq' operator so 
 among other things it is case sensitive.

 The two implementations are:
 Std    - the Standard version and the
          Array::Unique::Std
 IxHash - a version using the Tie::IxHash module of
          Gurusamy Sarathy
          Array::Unique::IxHash;

 You can select which implementation you would like to
 use by providing its name in the tie construct.
 The default currently is the Standard implementation.

 The main differences between the two implementations
 are speed and memory usage. 
 The Standard version uses about the same amount of space 
 as a regular array but adding new values takes O(n) time 
 so filling in an originally empty array will take O(n^2) time.

 The IxHash implementation requires installing Tie::IxHash
 uses about 4 times more space than a regular array but
 it is should be faster than the the Standard implementation.

 The module does not allow undef as a value in the array.

=head1 EXAMPLES

 use Array::Unique;
 tie @a, Array::Unique;

 @a = qw(a b c a d e f);
 push @a, qw(x b z);
 print "@a\n";          # a b c d e f x z

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

=head1 BUGS

 I think you cannot use two different implementations
 in the same script.

 Cannot use negative indexes in Splice (?)

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

 Copyright (C) 2002 Gabor Szabo <gabor@perl.org.il>
 All rights reserved.

 You may distribute under the terms of either the GNU 
 General Public License or the Artistic License, as 
 specified in the Perl README file.

 No WARRANTY whatsoever.

=head1 SUPPORT

 There is no official support for this package but
 you can send bug reports directly to the author.

 To get other support answers you should use either
 the Hungarian Perl mailing list at perl@atom.hu
 if you want to ask in Hungarian or the Israeli Perl 
 mailing list at http://www.perl.org.il/ in English.

=head1 CREDITS

 Thanks for suggestions and bug reports to 
 Szabo Balazs (dLux)
 Shlomo Yona
 Gaal Yahas

=head1 VERSION

 Version: 0.03      
 Date:    2002.07.27

=cut
