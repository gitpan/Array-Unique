# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 16 };

# ---------------------------------------------------
# Check if module is loading
# ---------------------------------------------------
eval { require Array::Unique; };
ok($@, '');
exit if $@;

# ---------------------------------------------------
# New instance creation
# ---------------------------------------------------
my @a;
my $o;

eval {$o = tie @a, "Array::Unique";};
ok($@, '');
# How can I mark that this is a fatal error ?


# ---------------------------------------------------
# create a simple array
# ---------------------------------------------------
@a=(2,3);
ok("@a" eq "2 3");

# ---------------------------------------------------
# create an array where there were dupplicates
# ---------------------------------------------------
@a=qw(a b c a d a b q a);
ok("@a" eq "a b c d q");
#print "DEBUG: '@a'\n";

# ---------------------------------------------------
# set a value in a specific index
# ---------------------------------------------------
@a=(2, 3);
$a[2] = 6;
ok("@a" eq "2 3 6");
#print "DEBUG: @a\n";

$a[3] = 6;
ok("@a" eq "2 3 6");
#print "DEBUG: @a\n";

$a[1] = 2;
ok("@a" eq "2 6");
#print "DEBUG: @a\n";

$a[7] = 'a';
ok("@a" eq "2 6 a");
#print "DEBUG: @a\n";

$a[7] = '6';
ok("@a" eq "2 6 a");
#print "DEBUG: @a\n";

$#a=1;
ok("@a" eq "2 6");
#print "DEBUG: @a\n";


# ---------------------------------------------------
# push
# ---------------------------------------------------
push @a, 2;
ok("@a" eq "2 6");
#print "DEBUG: '@a'\n";

push @a, 4;
ok("@a" eq "2 6 4");
#print "DEBUG: @a\n";

push @a, 7,2,8,3,10;
ok("@a" eq "2 6 4 7 8 3 10");
#print "DEBUG: @a\n";


# ---------------------------------------------------
# unshift
# ---------------------------------------------------
unshift @a, 5, 2, 6, 4;
ok("@a" eq "5 2 6 4 7 8 3 10");
#ok("@a" eq "5 6 2 3 4 7 8 10");
#print "DEBUG: '@a'\n";



# ---------------------------------------------------
# splice
# ---------------------------------------------------
@b = splice(@a, 2, 3);
ok("@b" eq "6 4 7");
ok("@a" eq "5 2 8 3 10");


# pop
# shift
# size like in $#a
# set size to a high value
# scalar (@a)
# set empty array 
# exists ?
# delete ?


