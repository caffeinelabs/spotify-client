/// The type of the album. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// AlbumBaseAlbumType.mo
/// Enum values: #album, #single, #compilation

module {
    public type AlbumBaseAlbumType = {
        #album;
        #single;
        #compilation;
    };

    public module JSON {
        public func toCandidValue(value : AlbumBaseAlbumType) : Candid.Candid =
            switch (value) {
                case (#album) #Text("album");
                case (#single) #Text("single");
                case (#compilation) #Text("compilation");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?AlbumBaseAlbumType =
            switch (candid) {
                case (#Text("album")) ?#album;
                case (#Text("single")) ?#single;
                case (#Text("compilation")) ?#compilation;
                case _ null;
            };

        public func toText(value : AlbumBaseAlbumType) : Text =
            switch (value) {
                case (#album) "album";
                case (#single) "single";
                case (#compilation) "compilation";
            };
    };
};
