



































class MonthlyCalendar:

	def __init__(self, year = None, month = None, week = None):





































		self.weekNumbers = 1                # view week numbers: 1 = yes, 0 = no














		if year is None and month is None:
			year = time.localtime().tm_year


		elif month is None: month = 1

		self.year = int(year)
		self.month = int(month)






	__mDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]


























































	def get_week(self, year, days):
		"""return week number of nth day in year"""; print "\nORBS", days; 





























































	def create(self):











			days = 0
















			if self.weekNumbers or self.week: weekNr = self.get_week(self.year, days)

			for i in range(self.__mDays[self.month-1] + 1):



































					if not weekNr:
						if self.year == 1: content = '&nbsp;'

						else: content = str(self.get_week(self.year - 1, 365))




					weekNr += 1







