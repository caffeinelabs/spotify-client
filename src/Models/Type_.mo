/// The type of entity to return. Valid values: `artists` or `tracks` 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// Type_.mo
/// Enum values: #artists, #tracks

module {
    public type Type_ = {
        #artists;
        #tracks;
    };

    public module JSON {
        public func toCandidValue(value : Type_) : Candid.Candid =
            switch (value) {
                case (#artists) #Text("artists");
                case (#tracks) #Text("tracks");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?Type_ =
            switch (candid) {
                case (#Text("artists")) ?#artists;
                case (#Text("tracks")) ?#tracks;
                case _ null;
            };

        public func toText(value : Type_) : Text =
            switch (value) {
                case (#artists) "artists";
                case (#tracks) "tracks";
            };
    };
};
