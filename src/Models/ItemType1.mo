/// The ID type. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ItemType1.mo
/// Enum values: #artist, #user

module {
    public type ItemType1 = {
        #artist;
        #user;
    };

    public module JSON {
        public func toCandidValue(value : ItemType1) : Candid.Candid =
            switch (value) {
                case (#artist) #Text("artist");
                case (#user) #Text("user");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?ItemType1 =
            switch (candid) {
                case (#Text("artist")) ?#artist;
                case (#Text("user")) ?#user;
                case _ null;
            };

        public func toText(value : ItemType1) : Text =
            switch (value) {
                case (#artist) "artist";
                case (#user) "user";
            };
    };
};
