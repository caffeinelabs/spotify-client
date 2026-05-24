/// The object type. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ArtistObjectType.mo
/// Enum values: #artist

module {
    public type ArtistObjectType = {
        #artist;
    };

    public module JSON {
        public func toCandidValue(value : ArtistObjectType) : Candid.Candid =
            switch (value) {
                case (#artist) #Text("artist");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?ArtistObjectType =
            switch (candid) {
                case (#Text("artist")) ?#artist;
                case _ null;
            };

        public func toText(value : ArtistObjectType) : Text =
            switch (value) {
                case (#artist) "artist";
            };
    };
};
