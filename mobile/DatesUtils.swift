import UIKit

class DatesUtils: NSObject {
    
    static func getTimeIntervalBy(year: Int) -> TimeInterval {
        return TimeInterval(60 * 60 * 24 * (year*365))
    }
    
    static func getDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "fr_FR")
        dateFormatter.dateFormat = "dd MM yyyy"
        
        return dateFormatter.string(from: date).replacingOccurrences(of: " ", with: "/")
    }
    
    static func getDateFromDatePicker(datePicker: UIDatePicker) -> Date {
        datePicker.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        return dateFormatter.date(from: self.getDateToString(date: datePicker.date))!
    }
    
    static func getDateStringFromDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
        return  dateFormatter.date(from: date)! //according to date format your date string
    }
    
    static func setNoHoursToDate(date:Date) -> Date {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let now = NSDate()
        var components = gregorian.components([.year, .month, .day, .hour, .minute, .second], from: date)
        
        components.hour = 1
        components.minute = 0
        components.second = 0
        
        return gregorian.date(from: components)!
    }
}
