
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/WebAPI }
using { /UnrealEngine.com/JSON }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
web_api_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Print("Web API Device Started")
        JsonString := "\{\"hoge\" : [\"fuga\", \"fuga2\"],\"foo\" : \{\"bar\" : null\}\}"
        
        #Client := MakeClient()
        #Response := Client.Get("https://api.example.com")

        if (JsonValue := Parse[JsonString]):
            Print(DeserializeValue(JsonValue))
        else:
            Print("Failed to parse JSON")

    DeserializeValue(Json : value) : string=
        if (String := Json.AsString[]):
            return String
        else if (Integer := Json.AsInt[]):
            return "{Integer}"
        else if (Float := Json.AsFloat[]):
            return "{Float}"
        else if (Json.AsNull[]):
            return "null"
        else if (ValueArray := Json.AsArray[]):
            return DeserializeValues(ValueArray)
        else if (ValueObject := Json.AsObject[]):
            return DeserializeObjects(ValueObject)
        else:
            return ""

    DeserializeValues(JsonArray : []value) : string =
        if (X := JsonArray[0], Xs := JsonArray.RemoveElement[0]):
            return DeserializeValue(X) + DeserializeValues(Xs)
        else:
            return ""

    DeserializeObjects(JsonObjects : [[]char]value) : string =
        var Index : int = 0
        var FirstKey : string = ""
        var FirstValue : value = value{}
        var NewMap : [[]char]value = map{}
        for (Key -> Value : JsonObjects):
            if (Index = 0):
                set FirstKey = Key
                set FirstValue = Value
            else:
                set NewMap = ConcatenateMaps(NewMap, map{Key => Value})
            set Index += 1
        if (Index = 1):
            return FirstKey + DeserializeValue(FirstValue)
        return FirstKey + DeserializeValue(FirstValue) + DeserializeObjects(NewMap)
