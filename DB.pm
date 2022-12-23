use Mojolicious::Lite;
use DBI;

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
1;