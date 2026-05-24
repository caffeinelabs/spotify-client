/// The ID type: either `artist` or `user`. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ItemType2.mo
/// Enum values: #artist, #user

module {
    public type ItemType2 = {
        #artist;
        #user;
    };

    public module JSON {
        public func toCandidValue(value : ItemType2) : Candid.Candid =
            switch (value) {
                case (#artist) #Text("artist");
                case (#user) #Text("user");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?ItemType2 =
            switch (candid) {
                case (#Text("artist")) ?#artist;
                case (#Text("user")) ?#user;
                case _ null;
            };

        public func toText(value : ItemType2) : Text =
            switch (value) {
                case (#artist) "artist";
                case (#user) "user";
            };
    };
};
