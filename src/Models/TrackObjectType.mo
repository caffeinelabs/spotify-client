/// The object type: \"track\". 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// TrackObjectType.mo
/// Enum values: #track

module {
    public type TrackObjectType = {
        #track;
    };

    public module JSON {
        public func toCandidValue(value : TrackObjectType) : Candid.Candid =
            switch (value) {
                case (#track) #Text("track");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?TrackObjectType =
            switch (candid) {
                case (#Text("track")) ?#track;
                case _ null;
            };

        public func toText(value : TrackObjectType) : Text =
            switch (value) {
                case (#track) "track";
            };
    };
};
