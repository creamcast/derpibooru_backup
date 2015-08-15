use strict;
use JSON;
use LWP::Simple;
use File::Fetch;

my $userid = $ARGV[0];
if ($userid eq undef){ print "no user key specified. please enter your user key as the argument. The key can be found in your derpibooru accounts page"; exit 1;}

my $page = 1;
my $fav_url = "";
my $json = "";
my $data = "";

while ( 1 ) {
	$fav_url = "https://derpibooru.org/images/favourites.json?page=$page&key=" . $userid;
	$json = "";
	
	#FETCH JSON
	$json = get($fav_url);
	if ($json eq undef){
		print "could not fetch page";
		exit 1;
	}else{
		print $fav_url . ". OK\n";
	}
	
	#DECODE JSON
	$data = decode_json($json);
	my $elements = scalar @{$data->{'images'}};
	
	#check if valid page
	#if ($page == 2){last;}
	if ($elements == 0) { 
		last; 
	}else{
		#DL images
		print "images:" . $elements . "\n";
		print "page:" . $page . "\n";
		foreach my $img (@{$data->{'images'}}){
			print "DOWNLOADING http:" . $img->{'image'} . "...";
			my $ff = File::Fetch->new(uri => "http:" . $img->{'image'});
			$ff->fetch() or die $ff->error;
			print " OK\n";
		}
		$page++;
	}
}
print "done\n";
