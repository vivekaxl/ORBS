package CALENDAR;
































sub initialize {
	my $this = shift;





































	$this->{weekNumbers} = 1;					# view week numbers: 1 = yes, 0 = no























}

sub new {



	my $self = {};
	bless $self;
	$self->initialize();










	return $self;

































































}

sub get_week {
	my ($this, $year, $days) = @_;print "\nORBS: $days\n";













































































}

sub create {
	my $this = shift;








	if($this->{wFontSize} > $this->{size}) { $this->{size} = $this->{wFontSize}; }



	else {

		for($i = $days = 0; $i < $this->{month} - 1; $i++) { $days += $this->{mDays}[$i]; }















		if($this->{weekNumbers} || $this->{week}) { $weekNr = $this->get_week($this->{year}, $days); }

		for($i = 0; $i <= $this->{mDays}[$this->{month}-1]; $i++) {


















			for($i = $wdays = 0; $i <= 6; $i++) {








				if(($daycount == 1 && $i < $start) || $daycount > $stop) { $content = '&nbsp;'; }
				else {





					$daycount++;







					if($this->{year} == 1) { $content = '&nbsp;'; }

					else { $content = $this->get_week($this->{year} - 1, 365); }
				}





			}

		}

	}

}












return 1;
