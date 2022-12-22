#!/usr/bin/env perl

use Mojolicious::Lite;
# connect to database
use DBI;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(get_dbh create_table);

# sub get_dbh{
	# my $dsn = "DBI:SQLite:dbname:cdr.sqlite";
	# my $dbh = DBI->connect(
    # "$dsn", "", "",
    # {
        # RaiseError => 1, AutoCommit => 0
    # }
    # );
	# return $dbh;
# }

sub create_table {
	my $dbh = get_dbh();

	$dbh->do(<<'SQL');
	CREATE TABLE IF NOT EXISTS CDR (
		caller_id        VARCHAR,
		recipient        VARCHAR,
		call_date        DATETIME_INT,
		end_time         DATETIME_INT,
		duration         INT,
		cost             REAL,
		reference        VARCHAR,
		currency         VARCHAR
	)
SQL
}





sub get_dbh {
    my $class = shift;
    my $driver = "SQLite";
    my $database = "cdr.db";
    my $dsn = "DBI:$driver:$database";
    my $userid = "";
    my $password = "";
    my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1}) or die $DBI::errstr;
    return $dbh;
}
sub insert {
    my $self = shift;
    my ($id, $firstName, $lastName, $email, $comment) = @_;
    my $sth = $self->{ dbh }->prepare("INSERT INTO COMPANY VALUES (?, ?, ?, ?, ?)");
    my $rv = $sth->execute($id, $firstName, $lastName, $email, $comment) or die $DBI::errstr;

    my $value = "Inserted Successfully";
    if($rv < 0){
        $value = $DBI::errstr;
    }
    return $value;
}

1;
__END__

# shortcut for use in template
helper db => sub { $dbh }; 

# setup base route
any '/' => 'index';

my $insert;
while (1) {
  # create insert statement
  $insert = eval { $dbh->prepare('INSERT INTO people VALUES (?,?)') };
  # break out of loop if statement prepared
  last if $insert;

  # if statement didn't prepare, assume its because the table doesn't exist
  warn "Creating table 'people'\n";
  $dbh->do('CREATE TABLE people (name varchar(255), age int);');
}

# setup route which receives data and returns to /
post '/insert' => sub {
  my $self = shift;
  my $name = $self->param('name');
  my $age = $self->param('age');
  $insert->execute($name, $age);
  $self->redirect_to('/');
};

app->start;

__DATA__

@@ index.html.ep
% my $sth = db->prepare('SELECT * FROM people');
% $sth->execute;

<!DOCTYPE html>
<html>
<head><title>People</title></head>
<body>
  <form action="<%=url_for('insert')->to_abs%>" method="post">
    Name: <input type="text" name="name"> 
    Age: <input type="text" name="age"
    <input type="submit" value="Add">
  </form>
  <br>
  Data: <br>
  <table border="1">
    <tr>
      <th>Name</th>
      <th>Age</th>
    </tr>
    % while (my $row = $sth->fetchrow_arrayref) {
      <tr>
        % for my $text (@$row) {
          <td><%= $text %></td>
        % }
      </tr>
    % }
  </table>
</body>
</html>