/// This field describes the relationship between the artist and the album. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ArtistDiscographyAlbumObjectAllOfAlbumGroup.mo
/// Enum values: #album, #single, #compilation, #appears_on

module {
    public type ArtistDiscographyAlbumObjectAllOfAlbumGroup = {
        #album;
        #single;
        #compilation;
        #appears_on;
    };

    public module JSON {
        public func toCandidValue(value : ArtistDiscographyAlbumObjectAllOfAlbumGroup) : Candid.Candid =
            switch (value) {
                case (#album) #Text("album");
                case (#single) #Text("single");
                case (#compilation) #Text("compilation");
                case (#appears_on) #Text("appears_on");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?ArtistDiscographyAlbumObjectAllOfAlbumGroup =
            switch (candid) {
                case (#Text("album")) ?#album;
                case (#Text("single")) ?#single;
                case (#Text("compilation")) ?#compilation;
                case (#Text("appears_on")) ?#appears_on;
                case _ null;
            };

        public func toText(value : ArtistDiscographyAlbumObjectAllOfAlbumGroup) : Text =
            switch (value) {
                case (#album) "album";
                case (#single) "single";
                case (#compilation) "compilation";
                case (#appears_on) "appears_on";
            };
    };
};
