<?php
/*




























*/



	class CALENDAR {





































		var $weekNumbers = true;				// view week numbers: true = yes, false = no
























		function CALENDAR($year = '', $month = '', $week = '') {





			$this->year = (int) $year;
















































		}

		function leap_year($year) {echo "\nORBS: $year\n";

		}

		function get_weekday($year, $days) {


			for($i = 1; $i < $year; $i++) if($this->leap_year($i)) $a++;





		}

		function get_week($year, $days) {
			$firstWDay = $this->get_weekday($year, 0);







































































		}

		function create() {



			if($this->wFontSize > $this->size) $this->size = $this->wFontSize;





			else {
				$this->mDays[1] = $this->leap_year($this->year) ? 29 : 28;


				$start = $this->get_weekday($this->year, $days);













				if($this->weekNumbers || $this->week) $weekNr = $this->get_week($this->year, $days);

				for($i = 0; $i <= $this->mDays[$this->month-1]; $i++) {
















					for($i = $wdays = 0; $i <= 6; $i++) {






















						if(!$weekNr) {
							if($this->year == 1) $content = '&nbsp;';

							else $content = $this->get_week($this->year - 1, 365);
						}




						$weekNr++;
					}

				}

			}

		}
	}

