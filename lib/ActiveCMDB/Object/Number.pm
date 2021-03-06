package ActiveCMDB::Object::Number;

use 5.010;
use namespace::autoclean;
use MooseX::DeclareX
	keywords => [qw(class exception)],
	plugins  => [qw(public private)],
	types 	 => [ -Moose ]; 

class ActiveCMDB::Object::Number
{
	has	'value'		=> (
		is		=> 'rw',
		isa		=> 'Maybe[Any]'		
	);
	
	has 'required'	=> (
		is		=> 'rw',
		isa		=> 'Int'
	);
	
	has 'verify'	=> (
		is		=> 'rw',
		isa		=> 'Maybe[Str]'
	);
	
	has 'range'		=> (
		is		=> 'rw',
		isa		=> 'Maybe[Str]'
	);
	
	has 'enum'		=> (
		is		=> 'rw',
		isa		=> 'Maybe[Str]'
	);
	
	has 'map'		=> (
		is		=> 'rw',
		isa		=> 'Maybe[Str]'
	);
	
	public method check {
		if ( $self->required && !defined($self->value) ) {
			return (0,"Undefined value, while required");
		}
		if ( $self->value !~ /^\d+$/ ) {
			return (0, "Value not decimal");	
		}
		if ( defined($self->enum) && defined($self->value) )
		{
			my $found = 0;
			foreach ( split(/\,/, $self->enum) ) { if ( $self->value == $_ ) { $found = 1 } }
			if ( $found == 0 ) {
				return (0, "Value not found in enum set");
			}
		} 
		if ( defined($self->range) && defined($self->value) )
		{
			my($min,$max) = sort {$a <=> $b} split(/\,/, $self->range, 2);
			if ( $self->value < $min || $self->value > $max ) {
				return(0, "Value outside defined range");
			}
		}
		
		return 1;
	}
};

1;