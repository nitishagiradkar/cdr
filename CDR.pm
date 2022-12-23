package CDR;

use lib "/home/niti/src/cdr";
use strict;
use Data::Dumper;
use Text::CSV_XS;
use DB;


sub new {
   my $class = shift;
   my $self = {};
   bless $self, $class;
   create_table();
   return $self;
}

sub long_call{
	my ($self, $param) = @_;
	
	my $fr_date = $param->{'fr_date'};
	my $to_date = $param->{'to_date'};
	my $p_fr_time = $param->{'fr_time'};
	my $p_to_time = $param->{'to_time'};
	
	my $dbh = get_dbh();
    my $sth = $dbh->prepare(<<'SQL');
    SELECT caller_id,recipient,call_date,end_time,duration,cost,reference,currency, MAX(duration) maxDur
    FROM    CDR
    --WHERE call_date BETWEEN ? AND ?
SQL
    #$sth->bind_param( 1, $fr_date );
	#$sth->bind_param( 2, $to_date );
    $sth->execute();
	my $result = [];
    while(my $row = $sth->fetchrow_arrayref){
		my $hash = {};
		$hash->{caller_id} = $row->[0];
		$hash->{recipient} = $row->[1];
		$hash->{call_date} = $row->[2];
		$hash->{end_time} = $row->[3];
		$hash->{duration} = $row->[4];
		$hash->{cost}     = $row->[5];
		$hash->{reference} = $row->[6];
		$hash->{currency} = $row->[7];
		push (@$result,$hash);
	}
	return $result;
}

sub avg_cost{
	my ($self, $param) = @_;
	my $fr_date = $param->{'fr_date'};
	my $to_date = $param->{'to_date'};
	my $p_fr_time = $param->{'fr_time'};
	my $p_to_time = $param->{'to_time'};
	
	my $dbh = get_dbh();
    my $sth = $dbh->prepare(<<'SQL');
        SELECT  AVG(cost) avgCost
            FROM    CDR
    --WHERE call_date BETWEEN ? AND ?
SQL
    #$sth->bind_param( 1, $fr_date );
	#$sth->bind_param( 2, $to_date );
    $sth->execute();

    my $result = $sth->fetchrow_hashref;

	return $result;
	
}

sub avg_call{
	my ($self, $param) = @_;
	
}

sub store_db{
	my ($self, $file) = @_;

	if (-f $file){
		my $dbh = get_dbh();
		create_table();
		# Using bind parameters avoids having to recompile the statement every time
		my $sth = $dbh->prepare(<<'SQL');
		INSERT INTO CDR
			   (caller_id,recipient,call_date,end_time,duration,cost,reference,currency)
		VALUES (?,?,?,?,?,?,?,?)
SQL

		my $csv = Text::CSV_XS->new or die;
		open my $fh, "<", $file;
		while(my $row = $csv->getline($fh)) {
			next if ($row =~ /caller_id/i); # ignore header row from csv file
			$sth->execute(@$row);
		}
		$csv->eof;
		close $fh;

		$sth->finish;    
		$dbh->commit;
		
	}
}

1;