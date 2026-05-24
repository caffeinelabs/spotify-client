/// The object type. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// AudiobookBaseType.mo
/// Enum values: #audiobook

module {
    public type AudiobookBaseType = {
        #audiobook;
    };

    public module JSON {
        public func toCandidValue(value : AudiobookBaseType) : Candid.Candid =
            switch (value) {
                case (#audiobook) #Text("audiobook");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?AudiobookBaseType =
            switch (candid) {
                case (#Text("audiobook")) ?#audiobook;
                case _ null;
            };

        public func toText(value : AudiobookBaseType) : Text =
            switch (value) {
                case (#audiobook) "audiobook";
            };
    };
};
