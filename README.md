# SafeDictionary

This is a safe, simple, lightweight dictionary object that does not throw exceptions, useful for parsing JSON.

## Usage

Take the following JSON for example

    {
      "success" : true,
      "code" : 200,
      "message" : "Success!",
      "result" : {
        "numberOfUnicorns" : 4,
        "names" : [
          "Unicorn One",
          "Unicorn Three",
          "Unicorn Tricorn",
          "Unicorn Popcorn",
        ]
      }
    }
    
A new `SafeDictionary` can be initialized using `SafeDictionary(rawJSON: String)`, `SafeDictionary(rawJSON: [String : AnyObject]?)`, `SafeDictionary(fromData: Data?)`, or using `SafeDictionary(value: NSDictionary?)`

To go deeper into the JSON tree, just index the object using `["key"]` or `[numberKey]`. To get the value at the current index, use the variables `.boolean`, `.number`, `.string`, `.arrayOfDictionaries`, etc.

    let dict: SafeDictionary
    
    //all of these will return nil if not found
    dict.string //String?
    dict.boolean //Bool?
    dict.number //Int?
    dict.cgFloat //CGFloat?
    dict.dictionary //[String : AnyObject]?
    dict.cocoaDictionary //NSDictionary?
    dict.image //UIImage?
    dict.array //[AnyObject]?
    dict.arrayOfDictionaries //[SafeDictionary]?
    dict.object //AnyObject?

For example, let's use `let dict: SafeDictionary` to represent the JSON above

    dict["success"]?.boolean //true
    dict["nonExistent"]?.boolean //nil
    dict["code"]?.number //200
    dict["message"]?.string //"Success!"
    dict["nonExistent"]?.string //nil
    
    dict["result"]?.boolean //nil
    dict["result"]?["numberOfUnicorns"]?.number //4
    dict["nonExistent"]?["nonExistent"]?["stillNonExistent"]?.string //nil
    
    dict["result"]?["names"]?.string //nil
    dict["result"]?["names"]?.stringArray //["Unicorn One", "Unicorn Three", "Unicorn Tricorn", "Unicorn Popcorn"]
    dict["result"]?["names"]?[0] //"Unicorn One"
    dict["result"]?["names"]?[3] //"Unicorn Popcorn"
    dict["result"]?["names"]?[4] //nil
    
`.arrayOfDictionaries` can be used to iterate through an array. For example, with the JSON

    {
        "array" : [
            "Value One",
            "Value Purple",
            "Value Banana",
        ]
    }
    
Taking `dict` as the `SafeDictionary` initialized with the JSON above,

    let dict: SafeDictionary? = wrapped["array"]
    for value in dict?.arrayOfDictionaries ?? []{
        print(", ");
        print(value?.string ?? "");
    }
    
    
Will print

    ", Value One, Value Purple, Value Banana"
