/// The ID type: currently only `artist` is supported. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ItemType.mo
/// Enum values: #artist

module {
    public type ItemType = {
        #artist;
    };

    public module JSON {
        public func toCandidValue(value : ItemType) : Candid.Candid =
            switch (value) {
                case (#artist) #Text("artist");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?ItemType =
            switch (candid) {
                case (#Text("artist")) ?#artist;
                case _ null;
            };

        public func toText(value : ItemType) : Text =
            switch (value) {
                case (#artist) "artist";
            };
    };
};
