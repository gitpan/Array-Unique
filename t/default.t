
# for testing type:
# make; make test
# for debugging uncomment the appropriate DEBUG entries and type
# make; perl -Iblib/lib t/default.t
# make; perl -d -Iblib/lib t/default.t


use Test;
BEGIN { 
   @modes = (undef, 'Std', 'IxHash');
   #@modes = ('Std');
   #@modes = ('IxHash');
   plan tests => (29 * @modes);
};

foreach my $m (@modes) {
    unit_test($m);
}


sub unit_test {
   my $mode = shift;

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

if (defined $mode) {
   eval {$o = tie @a, Array::Unique, $mode;};
} else {
   eval {$o = tie @a, Array::Unique;};
}
ok($@, '');
# How can I mark that this is a fatal error ?


# ---------------------------------------------------
# create a simple array
# ---------------------------------------------------
@a=qw(a b);
ok("@a" eq "a b");
#print "DEBUG: '@a'\n";

# ---------------------------------------------------
# create an array where there were dupplicates
# ---------------------------------------------------
@a=qw(a b c a d a b q a);
ok("@a" eq "a b c d q");
#print "DEBUG: '@a'\n";

# ---------------------------------------------------
# set empty array 
# ---------------------------------------------------
@a=();
ok("@a" eq "");


# ---------------------------------------------------
# set a value in a specific index
#   higher than any existing index (new value, existing value)
#   in the current range (new value)
#   in the current range old value, below old index
#   in the current range old value, at old index
#   in the current range old value, above old index
#
# ---------------------------------------------------
@a=qw(a b);
#print "DEBUG: '@a'\n";
$a[2] = 'c';
ok("@a" eq "a b c");
#print "DEBUG: '@a'\n";

$a[5] = 'd';
ok("@a" eq "a b c d");
#print "DEBUG: '@a'\n";

$a[8] = 'b';
ok("@a" eq "a b c d");
#print "DEBUG: '@a'\n";

$a[1] = 'x';
ok("@a" eq "a x c d");
#print "DEBUG: '@a'\n";

$a[2] = 'c';
ok("@a" eq "a x c d");
#print "DEBUG: @a\n";

$a[1] = 'd';
ok("@a" eq "a d c");
#print "DEBUG: @a\n";

$a[2] = 'a';
ok("@a" eq "a d");
#print "DEBUG: @a\n";


# ---------------------------------------------------
# fetch the value of a specific element in the array
# ---------------------------------------------------
ok($a[0] eq "a");



# ---------------------------------------------------
# change the size of the array
# check the size
# ---------------------------------------------------
$#a=10;
ok("@a" eq "a d");
#print "DEBUG: @a\n";

ok($#a == 1);

ok(2 == scalar @a);

$#a=0;
ok("@a" eq "a");
#print "DEBUG: @a\n";


# ---------------------------------------------------
# push
# ---------------------------------------------------
push @a, 'b';
ok("@a" eq "a b");
#print "DEBUG: '@a'\n";

push @a, 'c', 'd';
ok("@a" eq "a b c d");
#print "DEBUG: @a\n";

push @a, qw(x y d z a);
ok("@a" eq "a b c d x y z");
#print "DEBUG: @a\n";


# ---------------------------------------------------
# splice
# ---------------------------------------------------
@b = splice(@a, 2, 3);
ok("@b" eq "c d x");
#print "DEBUG: '@b'\n";
ok("@a" eq "a b y z");
#print "DEBUG: '@a'\n";

@b = splice(@a, 2, 1, qw(z a u));
ok("@b" eq "y");
#print "DEBUG: '@b'\n";
ok("@a" eq "a b z u");
#print "DEBUG: '@a'\n";


# ---------------------------------------------------
# unshift
# ---------------------------------------------------
unshift @a, qw(d a w);
ok("@a" eq "d a w b z u");
#print "DEBUG: '@a'\n";


# ---------------------------------------------------
# pop
# ---------------------------------------------------
$p = pop(@a);
ok($p eq "u");
ok("@a" eq "d a w b z");

# ---------------------------------------------------
# shift
# ---------------------------------------------------
$s = shift @a;
ok($s eq "d");
ok("@a" eq "a w b z");

# exists ?
# delete ?

}
