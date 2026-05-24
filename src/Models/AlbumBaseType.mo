/// The object type. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// AlbumBaseType.mo
/// Enum values: #album

module {
    public type AlbumBaseType = {
        #album;
    };

    public module JSON {
        public func toCandidValue(value : AlbumBaseType) : Candid.Candid =
            switch (value) {
                case (#album) #Text("album");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?AlbumBaseType =
            switch (candid) {
                case (#Text("album")) ?#album;
                case _ null;
            };

        public func toText(value : AlbumBaseType) : Text =
            switch (value) {
                case (#album) "album";
            };
    };
};
