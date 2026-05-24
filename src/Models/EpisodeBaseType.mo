/// The object type. 
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// EpisodeBaseType.mo
/// Enum values: #episode

module {
    public type EpisodeBaseType = {
        #episode;
    };

    public module JSON {
        public func toCandidValue(value : EpisodeBaseType) : Candid.Candid =
            switch (value) {
                case (#episode) #Text("episode");
            };

        public func fromCandidValue(candid : Candid.Candid) : ?EpisodeBaseType =
            switch (candid) {
                case (#Text("episode")) ?#episode;
                case _ null;
            };

        public func toText(value : EpisodeBaseType) : Text =
            switch (value) {
                case (#episode) "episode";
            };
    };
};
