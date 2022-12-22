use Mojolicious::Lite -signatures;
use lib "/home/niti/src/cdr";
use CDR;
#use File::Basename;
#use lib dirname . "/CDR.pm";

get '/call' => sub($c) {
    my $self = shift;
	#my $result = {name => 1};
	
	my $req  = {};
	$req->{p_opr}     = $c->param('opr');
	$req->{p_fr_date} = $c->param('fr_date');
	$req->{p_to_date} = $c->param('to_date');
	$req->{p_fr_time} = $c->param('fr_time');
	$req->{p_to_time} = $c->param('to_time');
	
	my $cdr = CDR->new();
	my $result = {};
	if ($req->{p_opr} eq "long-call"){
        $result = $cdr->long_call($req);
	}

	return $self->render(json => $result);
	#return $c->render(text => "Hello $user.")
};









# get '/questions/(:question_id)' => sub {
    # my $self = shift;
    # my $result = {};
    # # do stuff with $result based on $self->stash('question_id')
    # return $self->render_json($result)
# }

# Echo the request body and send custom header with response
post '/six' => sub ($c) {
  $c->res->headers->header('X-Bender' => 'hi!');
  $c->render(data => $c->req->body);
};

# payload base
post '/five' => sub ($c) {
  my $user = $c->param('user');
  $c->render(text => $c->req->body);
};

# parameter base
post '/four' => sub ($c) {
  my $user = $c->param('user');
  $c->render(text => "Hello $user.");
};


#user=sri
get '/three' => sub ($c) {
  my $user = $c->param('user');
  $c->render(text => "Hello $user.");
};

get '/one' => sub {
    my $self = shift;
    #my $result = { "name" => "Nitisha"};
	my $result = {"Nitisha"};
    # do stuff with $result based on $self->stash('question_id')
    #return $self->render_json($result);
	return $self->render(text => "Nitisha");
};


get '/two' => sub {
    my $self = shift;
    my %result = ('Sales' =>    {
                                'Brown' => 'Manager',
                                'Smith' => 'Salesman',
                                'Albert' => 'Salesman', 
                            }, 
            'Marketing' =>  {
                                'Penfold' => 'Designer',
                                'Evans' => 'Tea-person',
                                'Jurgens' => 'Manager', 
                            },
            'Production' => {
                                'Cotton' => 'Paste-up',
                                'Ridgeway' => 'Manager',
                                'Web' => 'Developer', 
                            },
            ); 
	
	# do stuff with $result based on $self->stash('question_id')
    #return $self->render_json($result);
	return $self->render(json => \%result);
};

app->start;