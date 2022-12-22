package CDR;

use lib "/home/niti/src/cdr";
use strict;
use Data::Dumper;
use Text::CSV_XS;
use DB;

# require Exporter;
# @ISA = qw(Exporter);
# @EXPORT = qw(long_call avg_cost avg_call);

#how to save data into db sqlight

sub new {
   my $class = shift;
   my $self = {};
   bless $self, $class;
   create_table();
   return $self;
}

sub long_call{
	my ($self, $param) = @_;
	#print STDERR Dumper $param;
	return {name => "asr"};
}

sub avg_cost{
	my ($self, $param) = @_;
	
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
			$sth->execute(@$row);
		}
		$csv->eof;
		close $fh;

		$sth->finish;    
		$dbh->commit;
		
	}
	
	
	
	
	
	
}


1;