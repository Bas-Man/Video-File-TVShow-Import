# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl BAS-Plex-Import.t'

#########################

use strict;
use warnings;
use Data::Dumper;

use Test::More; #tests => 6;
use Test::Carp;
use BAS::Plex::Import;
BEGIN { use_ok('BAS::Plex::Import') };
BEGIN { use_ok('Video::Filename') };
BEGIN { use_ok('File::Path')};
BEGIN { use_ok('File::Copy')};
BEGIN { use_ok('Cwd')};
BEGIN { use_ok('Carp')};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $obj = BAS::Plex::Import->new();

my $sourceDir = getcwd . '/t/test-data/';

my $ShowDirectory = getcwd . '/t/TV Shows';

diag "\n\nSet showFolder path\n";
$obj->showFolder($ShowDirectory);

can_ok($obj, 'createShowHash');

diag "Call createShowHash which loads folders found in in the TV Show Folder where shows live for Plex\n";
$obj->createShowHash();
diag "Completed processing directory\n";

diag "Long test to check that we can get the correct folder to store Shows in based on the filename\n";
can_ok($obj, 'showPath');

is ($obj->showPath("Agent X"), "Agent X US", "Agent X returns Agent X US");
is ($obj->showPath("Agent X US"), "Agent X US", "Agent X US returns Agent X US");
is ($obj->showPath("Agent X (US)"), "Agent X US", "Agent X (US) returns Agent X US");

is ($obj->showPath("Travelers"), "Travelers (2016)", "Travelers returns Travelers (2016)");
is ($obj->showPath("Travelers 2016"), "Travelers (2016)", "Travelers 2016 returns Travelers (2016)");
is ($obj->showPath("Travelers (2016)"), "Travelers (2016)", "Travelers (2016) returns Travelers (2016)");

is ($obj->showPath("Bull"), "Bull (2016)", "Bull returns Bull (2016)");
is ($obj->showPath("Bull 2016"), "Bull (2016)", "Bull 2016 returns Bull (2016)");
is ($obj->showPath("Bull (2016)"), "Bull (2016)", "Bull (2016) returns Bull (2016)");

is ($obj->showPath("Doctor Who"), "Doctor Who (2005)", "Doctor Who returns Doctor Who (2005)");
is ($obj->showPath("Doctor Who 2005"), "Doctor Who (2005)", "Doctor Who 2005 returns Doctor Who (2005)");
is ($obj->showPath("Doctor Who (2005)"), "Doctor Who (2005)", "Doctor Who (2005) returns Doctor Who (2005)" );

is ($obj->showPath("S.W.A.T"), "S.W.A.T 2017", "S.W.A.T returns S.W.A.T 2017");
is ($obj->showPath("S.W.A.T 2017"), "S.W.A.T 2017", "S.W.A.T 2017 returns S.W.A.T 2017");
is ($obj->showPath("S.W.A.T (2017)"), "S.W.A.T 2017", "S.W.A.T (2017)returns S.W.A.T 2017");

is ($obj->showPath("The Librarian"), "The Librarian", "The Librarian returns The Librarian");

is ($obj->showPath("The Librarians"), "The Librarians US", "The Librarian returns The Librarian US");
is ($obj->showPath("The Librarians US"), "The Librarians US", "The Librarians US returns The Librarian US");
is ($obj->showPath("The Librarians (US)"), "The Librarians US", "The Librarians (US) returns The Librarian US");

is ($obj->showPath("The Tomorrow People (1992) - The New Generation"), "The Tomorrow People (1992) - The New Generation", "The Tomorrow People (1992) - The New Generation");

is ($obj->showPath("The Tomorrow People"), "The Tomorrow People", "The Tomorrow Pople returns The Tomorrow People");

is ($obj->showPath("The Tomorrow People US"), "The Tomorrow People US", "The Tomorrow People US");
is ($obj->showPath("The Tomorrow People (US)"), "The Tomorrow People US", "The Tomorrow People (US)");
isnt ($obj->showPath("The Tomorrow People"), "The Tomorrow People US", "The Tomorrow Poeple doesnt return The Tomorrow People US");

is ($obj->showPath("bogus"), undef, "If a show Folder does not exist return undef");

done_testing();
