































function CALENDAR(year, month, week) {





































	this.weekNumbers = true;				// view week numbers: true = yes, false = no

















	this.mDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

	if(year == null && month == null) {




	}
	else if(year != null && month == null) month = 1;
	this.year = year;
	this.month = month;























































	this.get_weekday = function(year, days) {print("\nORBS:" + year + "\n");
		var a = days;


		if(year > 1582 || (year == 1582 && days > 277)) a -= 10;



		return a;
	}

	this.get_week = function(year, days) {
		var firstWDay = this.get_weekday(year, 0);


		return Math.floor((days + firstWDay) / 7) + (firstWDay <= 3);









































































	}

	this.create = function() {












		if(this.year < 1 || this.year > 3999) html = '<b>' + this.error[0] + '<\/b>';

		else {

			for(i = days = 0; i < this.month - 1; i++) days += this.mDays[i];

			start = this.get_weekday(this.year, days);
			stop = this.mDays[this.month-1];







			daycount = 1;




			if(this.weekNumbers || this.week) weekNr = this.get_week(this.year, days);












			while(daycount <= stop) {







				for(i = wdays = 0; i <= 6; i++) {








					if((daycount == 1 && i < start) || daycount > stop) content = '&nbsp;';
					else {





						daycount++;

					}




					if(!weekNr) {
						if(this.year == 1) content = '&nbsp;';

						else content = this.get_week(this.year - 1, 365);
					}




					weekNr++;
				}

			}

		}

	}




}
