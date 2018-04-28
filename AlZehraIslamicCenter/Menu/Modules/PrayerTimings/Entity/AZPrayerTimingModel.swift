
import Foundation
 

public class AZPrayerTimingModel {
	public var imsaak : String?
	public var fajr : String?
	public var sunrise : String?
	public var dhuhr : String?
	public var asr : String?
	public var sunset : String?
	public var maghrib : String?
	public var isha : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let AZPrayerTimingModel_list = AZPrayerTimingModel.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of AZPrayerTimingModel Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AZPrayerTimingModel]
    {
        var models:[AZPrayerTimingModel] = []
        for item in array
        {
            models.append(AZPrayerTimingModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let AZPrayerTimingModel = AZPrayerTimingModel(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: AZPrayerTimingModel Instance.
*/

	required public init?(dictionary: NSDictionary) {
        
        imsaak = timeToSeconds(timeString: (dictionary["Imsaak"] as? String) ?? "")
		fajr = timeToSeconds(timeString: (dictionary["Fajr"] as? String) ?? "")
		sunrise = timeToSeconds(timeString: (dictionary["Sunrise"] as? String) ?? "")
		dhuhr = timeToSeconds(timeString: (dictionary["Dhuhr"] as? String) ?? "")
		asr = timeToSeconds(timeString: (dictionary["Asr"] as? String) ?? "")
		sunset = timeToSeconds(timeString: (dictionary["Sunset"] as? String) ?? "")
		maghrib = timeToSeconds(timeString: (dictionary["Maghrib"] as? String) ?? "")
		isha = timeToSeconds(timeString: (dictionary["Isha"] as? String) ?? "")
	}
    
    func timeToSeconds(timeString: String) -> String {
        
        if timeString.count == 0 {
            return ""
        }
        
        let components = timeString.components(separatedBy: ":")
        var hours = Int(components[0]) ?? 0
        var minutes = Int(components[1]) ?? 0
        var seconds = (hours * 60 * 60) + (minutes * 60)
        
        if TimeZone.current.isDaylightSavingTime() {
            let offset = TimeZone.current.daylightSavingTimeOffset()
            seconds = seconds + lrint(offset)
        }
        
        hours = seconds / 3600
        minutes = (seconds % 3600) / 60

        let hoursStr = String(hours).count == 1 ? ("0" + String(hours)) : String(hours)
        let minutesStr = String(minutes).count == 1 ? ("0" + String(minutes)) : String(minutes)
        return hoursStr + ":" + minutesStr
    }

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.imsaak, forKey: "Imsaak")
		dictionary.setValue(self.fajr, forKey: "Fajr")
		dictionary.setValue(self.sunrise, forKey: "Sunrise")
		dictionary.setValue(self.dhuhr, forKey: "Dhuhr")
		dictionary.setValue(self.asr, forKey: "Asr")
		dictionary.setValue(self.sunset, forKey: "Sunset")
		dictionary.setValue(self.maghrib, forKey: "Maghrib")
		dictionary.setValue(self.isha, forKey: "Isha")

		return dictionary
	}

}
