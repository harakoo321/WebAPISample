using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/WebAPI }
using { /UnrealEngine.com/JSON }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level

deserialized_tuple := tuple(tuple(string, []string), tuple(string, tuple(string, string)))

web_api_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        Print("Web API Device Started")
        JsonString := "\{\"hoge\" : [ 1, 2, 3, 4, 5 ],\"foo\" : \{\"bar\" : null\}\}"
        
        #Client := MakeClient()
        #Response := Client.Get("https://api.example.com")

        Serialize(JsonString)

    Serialize(JsonString : string):void=
        if(JsonValue := Parse[JsonString]):
            Print("Serialize Start!")
            SerializedValue := SerializeValue(JsonValue)
            Print("Serialize End!")
            Print(ToDiagnostic(SerializedValue))
            <#
            if(SerializedValue := deserialized_tuple[SerializeValue(JsonValue)]):
                Tuple := SerializedValue(0)
                Print("Key: {Tuple(0)}")
            #>
        else:
            Print("Failed")

    SerializeValue(Json : value) : any=
        if (String := Json.AsString[]):
            return String
        else if (Integer := Json.AsInt[]):
            return Integer
        else if (Float := Json.AsFloat[]):
            return Float
        else if (Json.AsNull[]):
            return "NULL"
        else if (ValueArray := Json.AsArray[]):
            return SerializeValues(ValueArray)
        else if (ValueObject := Json.AsObject[]):
            return SerializeObjects(ValueObject)
        else:
            return ""

    SerializeValues(JsonArray : []value) : []any =
        if (X := JsonArray[0], Xs := JsonArray.RemoveElement[0]):
            return array{SerializeValue(X)} + SerializeValues(Xs)
        else:
            return array{}

    SerializeObjects(JsonObjects : [[]char]value) : tuple(any, any) =
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
            return (FirstKey, SerializeValue(FirstValue))
        return ((FirstKey, SerializeValue(FirstValue)), SerializeObjects(NewMap))
