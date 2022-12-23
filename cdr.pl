use strict;
use warnings;

use Mojolicious::Lite -signatures; # app, get, post is exported. 

use File::Basename 'basename';
use File::Path 'mkpath';
use lib "/home/niti/src/cdr";
use CDR;


# CSV base URL
my $CSV_BASE = '/home/niti/src/cdr/csv_store/csv';

# Directory to save csv files
# (app is Mojolicious object. static is MojoX::Dispatcher::Static object)
#my $CSV_DIR  = app->static->root . $CSV_BASE;
app->secrets(['nitisha']);
my $CSV_DIR  = $CSV_BASE;

# Create directory if not exists
unless (-d $CSV_DIR) {
    mkpath $CSV_DIR or die "Cannot create dirctory: $CSV_DIR";
}

get '/one' => sub {
    my $self = shift;
	return $self->render(text => "Hello ");
};

get '/call' => sub($c) {
    my $self = shift;
	
	my $req  = {};
	$req->{p_opr}     = $c->param('opr');
	$req->{p_fr_date} = $c->param('fr_date');
	$req->{p_to_date} = $c->param('to_date');
	$req->{p_fr_time} = $c->param('fr_time');
	$req->{p_to_time} = $c->param('to_time');
	
	my $cdr = CDR->new();
	my $result;
	if ($req->{p_opr} eq "long-call"){
        $result = $cdr->long_call($req);
	}elsif ($req->{p_opr} eq "avg-cost"){
        $result = $cdr->avg_cost($req);
	}
	return $self->render(json => $result);
};





# Upload csv file
post '/upload' => sub {
    my $self = shift;

    # Uploaded csv(Mojo::Upload object)
    my $csv = $self->req->upload();
	 
    unless ($csv) {
        return $self->render(
            text  => "Upload fail. File is not specified."
        );
    }
    
    # Upload max size 3 
    my $upload_max_size = 2 * 1024 * 1024 * 1024;

    # Over max size
    if ($csv->size > $upload_max_size) {
        return $self->render(
            #template => 'error',
            text  => "Upload fail. CSV size is too large."
        );
    }
    
    # Check file type
    my $csv_type = $csv->headers->content_type;
    my %valid_types = ("text/csv" => "csv");
    
    # Content type is wrong
    unless ($valid_types{$csv_type}) {
        return $self->render(
            text  => "Upload fail. Content type is wrong."
        );
    }
    
    # Extention
    my $exts = {'text/csv' => 'csv'};
    my $ext = $exts->{$csv_type};
    
    # csv file
    my $csv_file = "$CSV_DIR/" . create_filename(). ".$ext";
    
    # If file is exists, Retry creating filename
    while(-f $csv_file){
        $csv_file = "$CSV_DIR/" . create_filename() . ".$ext";
    }
    
    # Save to file
    $csv->move_to($csv_file);
	
	my $cdr = CDR->new();
	$cdr->store_db($csv_file);

	return $self->render(text => "File uploaded Successfully.");
    
} => 'upload';

sub create_filename {
  
    # Date and time
    my ($sec, $min, $hour, $mday, $month, $year) = localtime;
    $month = $month + 1;
    $year = $year + 1900;
    
    # Random number(0 ~ 99999)
    my $rand_num = int(rand 100000);

    # Create file name form datatime and random number
    # (like image-20091014051023-78973)
    my $name = sprintf("csv-%04s%02s%02s%02s%02s%02s-%05s",
                       $year, $month, $mday, $hour, $min, $sec, $rand_num);
    
    return $name;
	
}

app->start;