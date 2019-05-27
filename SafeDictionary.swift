/*
   Copyright 2019 Domenico Ottolia

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import Foundation

class SafeDictionary{
    
    var rawDictionary: [String : AnyObject]?
    let rawValue: AnyObject?
    
    convenience init(value: NSDictionary?){
        self.init(value: value as? [String : AnyObject])
    }
    
    convenience init?(fromData nsdata: NSData?){
        if let nsdata = nsdata{
            self.init(fromData: nsdata as Data)
        }
        else{return nil}
    }
    
    convenience init?(fromData data: Data?){
        guard let data = data else{return nil}
        do{
            if let parsed = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary{
                self.init(value: parsed)
            }
            else{return nil}
        }
        catch _{return nil}
    }
    
    init(value: [String : AnyObject]? = [:]){
        self.rawDictionary = value
        self.rawValue = value as AnyObject
    }
    
    init(value: AnyObject?){
        self.rawDictionary = value as? [String : AnyObject]
        self.rawValue = value
    }
    
    subscript(key: String) -> SafeDictionary?{
        let value = self.rawDictionary?[key]
        return SafeDictionary(value: value)
    }
   
   subscript(key: Int) -> SafeDictionary?{
        return self.arrayOfDictionaries?[key]
    }
    
    func contains(key: String) -> Bool{
        return self.rawDictionary?[key] != nil
    }
    
    func contains(keys: [String]) -> Bool{
        for key in keys{
            if self.rawDictionary?[key] == nil{
                return false
            }
        }
        return true
    }
    
    func jsonEncoded(withoutKeys keys: [String] = []) -> Data?{
        if let raw = self.rawDictionary{
            do{
               let new = NSMutableDictionary(dictionary: raw)
               new.removeObjects(forKeys: keys)
               return try JSONSerialization.data(withJSONObject: new, options: .init(rawValue: 0))
            }
            catch _{}        
        }
        return nil
    }
    
    var boolean: Bool?{
        get{
            return (self.rawValue as? NSNumber)?.boolValue ?? (self.rawValue as? Bool)
        }
    }
    
    var number: Int?{
        get{return self.rawValue as? Int ?? (self.rawValue is String ? Int(self.rawValue as! String) : nil)}
    }
    
    var cgFloat: CGFloat?{
        get{return self.rawValue is NSNumber ? CGFloat((self.rawValue as? NSNumber)?.doubleValue ?? 0) : nil}
    }
    
    var string: String?{
        get{return self.rawValue as? String ?? (self.number == nil ? nil : String(self.number!))}
    }
    
    var dictionary: [String : AnyObject]?{
        get{return self.rawDictionary}
    }
    
    var cocoaDictionary: NSDictionary?{
        get{return self.rawDictionary as NSDictionary?}
    }
    
    var image: UIImage?{
        get{return self.rawValue as? UIImage}
    }
    
    var array: [AnyObject]?{
        get{
            return self.rawValue as? [AnyObject]
        }
    }
   
   var stringArray: [String]?{
        get{
            return self.rawValue as? [String]
        }
    }
    
    var arrayOfDictionaries: [SafeDictionary]?{
        get{
            guard let array = self.array else{return nil}
            
            var dictionary: [SafeDictionary] = []
            for val in array{
                dictionary.append(SafeDictionary(value: val))
            }
            return dictionary
        }
    }
    
    var object: AnyObject?{
        get{return self.rawValue}
    }
}
